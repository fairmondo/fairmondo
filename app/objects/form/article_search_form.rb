class ArticleSearchForm
  include ActiveData::Model
  extend Enumerize
  delegate :formated_prices, to: :@price_range

  attribute :q, type: String
  attribute :fair, type: Boolean
  attribute :ecologic, type: Boolean
  attribute :small_and_precious, type: Boolean
  attribute :swappable, type: Boolean
  attribute :borrowable, type: Boolean

  attribute :condition, type: String
  attribute :category_id, type: Integer
  attribute :zip, type: String
  attribute :order_by, type: String,
                       default_blank: true,
                       default: ->(record) { record.search_by_term? ? :relevance : :newest }
  attribute :search_in_content, type: Boolean
  attribute :price_from, type: String
  attribute :price_to, type: String

  enumerize :condition, in: [:new, :old]
  enumerize :order_by, in: [:newest,:cheapest,:most_expensive,:old,:new,:fair,:ecologic,:small_and_precious,:most_donated]

  def searched_category category_id = self.category_id
    @searched_category ||= Category.includes(:children).find(category_id.to_i) rescue nil
  end

  def search page
    @search = ArticleSearch.search(self)
    @search.result.page(page).per(Kaminari.config.default_per_page)
  rescue Faraday::ConnectionFailed
    ArticlePolicy::Scope.new(nil, Article).resolve.page(page)
  end

  # for the category tree to display wich categories have which counts
  def category_article_count category_id
    @search.category_facet[category_id.to_s] || 0
  end

  def search_by_term?
    self.q.present?
  end

  # Did this form get request parameters or is this an empty search where someone just wants to look around?
  # (category doesn't count)
  def search_request?
    filter_attributes.reject{ |a,v| k==:category_id }.empty?
  end

  def fresh?
    filter_attributes.empty?
  end

  def change changes
    clean_hash self.attributes.merge(changes)
  end

  def flip parameter
    self.change(parameter => !self.send(parameter))
  end

  def keep
    filter_attributes
  end

  def search_form_attributes
    filter_attributes.reject { |k, v| [:q, :category_id].include?(k) }
  end

  def category_collection
    categories = Category.other_category_last.sorted.roots.to_a
    categories.push(Category.find(self.category_id)) if self.category_id.present?
    categories
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

  def price_range
    @price_range ||= PriceRangeParser.new(price_from, price_to)
    # set the values for proper formatting
    self.price_from, self.price_to = @price_range.form_values
    {gte: @price_range.from_cents , lte: @price_range.to_cents }
  end

  private

    def filter_attributes
      clean_hash self.attributes
    end

    def clean_hash hash
      hash.select{ |a,v| v!=nil && v!=false }
    end


end
