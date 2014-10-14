class ArticleSearchForm
  include Rails.application.routes.url_helpers
  extend ActiveModel::Naming
  extend Enumerize
  include Virtus.model
  include ActiveModel::Conversion

  attribute :q, String
  attribute :fair, BooleanFromParams
  attribute :ecologic, BooleanFromParams
  attribute :small_and_precious, BooleanFromParams
  attribute :swappable, BooleanFromParams
  attribute :borrowable, BooleanFromParams

  attribute :condition, String
  enumerize :condition, in: [:new, :old]
  attribute :category_id, Integer
  attribute :zip, String
  attribute :order_by, String
  enumerize :order_by, in: [:newest,:cheapest,:most_expensive,:old,:new,:fair,:ecologic,:small_and_precious,:most_donated]
  #   => :newest,"Preis aufsteigend" => :cheapest,"Preis absteigend" => :most_expensive
  attribute :search_in_content, Boolean
  attribute :price_from, String
  attribute :price_to, String
  attr_accessor :page


  def persisted?
    false
  end


  def searched_category category_id = self.category_id
    @searched_category ||= Category.includes(:children).find(category_id.to_i) rescue nil
  end


  def search page
    query = self

    articles = Article.search(:page => page,:per_page => Kaminari.config.default_per_page) do

      query do
        boolean minimum_should_match: 1 do
          if query.search_by_term?
            should { match "title.search", query.q, fuzziness: 0.9 , :zero_terms_query => 'all' }
            should { match :content, query.q } if query.search_in_content
            should { match :friendly_percent_organisation_nickname, query.q, :fuzziness => 0.7 }
            should { term :gtin, query.q, :boost => 100 }
          end
          must { term :fair, true } if query.fair
          must { term :ecologic, true } if query.ecologic
          must { term :small_and_precious, true } if query.small_and_precious
          must { term :swappable, true } if query.swappable
          must { term :borrowable, true } if query.borrowable
          must { term :condition, query.condition}  if query.condition
          must { prefix :zip, query.zip } if query.zip.present?
          must { range :price, query.price_range }
        end
      end

      filter :terms, :categories => [query.category_id] if query.category_id.present?

      facet 'categories' do
        terms :categories, size: 10000 # If we ever hit 10000 categories+ this has to be upgraded
      end

      if query.order_by
        attribute, order = ArticleSearchForm.sort_order query.order_by
        sort { by attribute, order}
      else
        # Sort by score
        sort { by :created_at, :desc  } unless query.search_by_term?
      end

    end
    @category_facets = Hash[articles.facets['categories']['terms'].map(&:values)] if articles.facets
    articles
  rescue Errno::ECONNREFUSED
    articles = ArticlePolicy::Scope.new(nil, Article).resolve.page(page)
  end

  # for the category tree to display wich categories have which counts
  def category_article_count category_id
    @category_facets[category_id.to_s] || 0
  end


  def price_range
    hash = {}
    from,to = parse_price_range
    hash[:gte] = normalize_price_from from
    hash[:lte] = normalize_price_to from, to
    hash
  end

  def autocomplete
    query = self
    max_results = 5
    search = Article.search do
      size max_results
      query do
        match "title.decomp", query.q, fuzziness: 0.9
      end
      suggest :typos do
        text query.q
        term "title.decomp", :suggest_mode => 'popular', :sort => 'frequency' , :analyzer => :simple, size: 3
      end
    end
    suggestions = search.suggestions.texts.map { |suggest|  {value: suggest, data: {type: :suggest}} }
    suggestions += search.results.map{ |result|  {value: result.title, data: { type: :result, url: article_path(result.slug), thumb: ActionController::Base.helpers.image_tag(result.title_image_url_thumb)}}}
    suggestions += [{ value: query.q, data: { type: :more, count: search.total }}] if search.total > max_results
    return { query: query.q, suggestions: suggestions }
  end


  ## Is this still used??
  # def self.categories_for_filter form
  #   if form.object.category_id.present?
  #     Category.find(form.object.category_id).self_and_ancestors.map(&:id).to_json
  #   else
  #     [].to_json
  #   end
  # end


  def search_by_term?
    self.q && !self.q.empty?
  end


  # Did this form get request parameters or is this an empty search where someone just wants to look around?
  # (category doesn't count)
  def search_request?
    !q.blank? || fair || ecologic || small_and_precious || condition || !zip.blank? || order_by || @page
  end

  def fresh?
    self.attributes.select{ |a,v| v!=nil && v!=false }.empty?
  end

  def change changes
    changed = self.attributes.merge(changes)
    clean_hash changed
  end

  def flip parameter
    self.change(parameter => !self.send(parameter))
  end

  def keep
    clean_hash self.attributes
  end

  def search_form_attributes
    clean_hash(self.attributes.reject { |k, v| [:q, :category_id].include?(k) })
  end

  def category_collection
    categories = Category.other_category_last.sorted.roots.to_a
    categories.push(Category.find(self.category_id)) if self.category_id && self.category_id != ''
    categories
  end

  def format_price_range
    if price_given?(:from) && price_given?(:to)
      "#{self.price_from} - #{self.price_to}"
    elsif price_given?(:from) && !price_given?(:to)
      "> #{self.price_from}"
    else
      nil
    end
  end

  def price_given?(price)
    value = self.send("price_#{price.to_s}")
    value && !value.empty?
  end

  def wegreen_search_string
    if search_by_term?
      q
    elsif searched_category
      searched_category.name
    else
      nil
    end
  end

  def self.sort_order order_by
      case order_by
      when "newest"
        [:created_at, :desc]
      when "cheapest"
        [:price, :asc]
      when "most_expensive"
        [:price, :desc]
      when "old"
        [:condition, :desc]
      when "new"
        [:condition, :asc]
      when "fair"
        [:fair, :desc]
      when "ecologic"
       [:ecologic, :desc]
      when "small_and_precious"
        [:small_and_precious, :desc]
      when "most_donated"
        [:friendly_percent, :desc]
      end
    end

  private



    def normalize_price_from from
      if from # && from.cents != 0
        self.price_from = from.format
        return from.cents
      end
    end

    def normalize_price_to from,to
      if to && to.cents >= 0 && to >= from
        self.price_to = to.format
        return to.cents
      end
    end

    def parse_price_range
      unless self.price_from.nil? && self.price_to.nil? || self.price_from == '' && self.price_to == ''
        [Monetize.parse(self.price_from), Monetize.parse(self.price_to)]
      else
        [nil,nil]
      end
    end

    def clean_hash(hash)
      # clean nil values and throw out false boolean attributes that result in filter not being attached
      hash.select do |k,v|
        v != nil && !([:fair,:ecologic,:small_and_precious].include?(k) && !v)
      end
    end

end
