class ArticleSearchForm
  extend ActiveModel::Naming
  extend Enumerize
  include Virtus.model
  include ActiveModel::Conversion


  # def self.article_search_form_attrs
  #   [:q, :fair, :ecologic, :small_and_precious, :condition,:category_id, :zip, :order_by, :search_in_content]
  # end


  attribute :q, String
  attribute :fair, BooleanFromParams
  attribute :ecologic, BooleanFromParams
  attribute :small_and_precious, BooleanFromParams

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
    @searched_category ||= Category.includes(:children).find(category_id) rescue nil
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
          must { term :fair,true } if query.fair
          must { term :ecologic, true } if query.ecologic
          must { term :small_and_precious, true } if query.small_and_precious
          must { term :condition, query.condition}  if query.condition
          must { term :zip,query.zip } if query.zip.present?
          must { range :price, query.price_range }
        end
      end

      filter :terms, :categories => [query.category_id] if query.category_id.present?

      facet 'categories' do
        terms :categories, size: 10000 # If we ever hit 10000 categories+ this has to be upgraded
      end

      case query.order_by
      when "newest"
        sort { by :created_at, :desc }
      when "cheapest"
        sort { by :price, :asc }
      when "most_expensive"
        sort { by :price, :desc }
      when "old"
        sort { by :condition, :desc }
      when "new"
        sort { by :condition, :asc }
      when "fair"
        sort { by :fair, :desc }
      when "ecologic"
        sort { by :ecologic, :desc }
      when "small_and_precious"
        sort { by :small_and_precious, :desc }
      when "most_donated"
        sort { by :friendly_percent, :desc }
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
    from = nil
    to = nil

    unless self.price_from.nil? && self.price_to.nil? || self.price_from == '' && self.price_to == ''
      from = Monetize.parse(self.price_from)
      to = Monetize.parse(self.price_to)
    end

    if from# && from.cents != 0
      self.price_from = from.format
      hash[:gte] = from.cents
    else
      hash[:gte] = nil
    end

    if to && to.cents >= 0 && to >= from
      self.price_to = to.format
      hash[:lte] = to.cents
    end
    hash
  end

  def autocomplete
    query = self
    search = Article.search do
      query do
        match "title.decomp", query.q, fuzziness: 0.9
      end
      highlight "title.decomp", :options => { number_of_fragments: 0, pre_tags: ["<b>"], post_tags: ["</b>"]}
      suggest :typos do
        text query.q
        term "title.decomp", :suggest_mode => 'popular', :sort => 'frequency' , :analyzer => :simple, size: 3
      end
    end
    suggestions = search.suggestions.texts.map { |suggest|  suggest }
    suggestions += search.results.map{ |result|  result.title }
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
    self.attributes.empty?
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
    ret = {}
    hash = clean_hash(self.attributes.reject { |k, v| [:q, :category_id].include?(k) })
    ret[:article_search_form] = hash unless hash.empty?
    ret
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

  private

    def clean_hash(hash)
      # clean nil values and throw out false boolean attributes that result in filter not being attached
      hash.select do |k,v|
        v != nil && !([:fair,:ecologic,:small_and_precious].include?(k) && !v)
      end
    end

end
