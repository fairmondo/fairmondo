class ArticleSearch
  include ActiveData::Model

  SORT = {  newest: { created_at: :desc },
            cheapest: { price: :asc },
            most_expensive: { price: :desc },
            old: { condition: :desc },
            new: { condition: :asc },
            fair: { fair: :desc },
            ecologic: { ecologic: :desc },
            small_and_precious: { small_and_precious: :desc },
            most_donated: { friendly_percent: :desc },
            relevance: :_score
  }.stringify_keys

  delegate :formated_prices, to: :@price_range

  attribute :q, type: String
  attribute :fair, type: Boolean
  attribute :ecologic, type: Boolean
  attribute :small_and_precious, type: Boolean
  attribute :swappable, type: Boolean
  attribute :borrowable, type: Boolean

  attribute :condition, type: String, enum: [:new, :old]
  attribute :category_id, type: Integer
  attribute :zip, type: String
  attribute :order_by, type: String,
                       enum: SORT.keys,
                       default_blank: true,
                       default: ->(record) { record.search_by_term? ? :relevance : :newest }
  attribute :search_in_content, type: Boolean
  attribute :price_from, type: String
  attribute :price_to, type: String

  # Index

  def index
    ArticlesIndex
  end

  # public api

  def search
    @search ||= [query,
                boolead_filters,
                zip_filter,
                price_filter,
                category_filter,
                condition_filter,
                category_facet].compact.reduce(:merge).query_mode(1)
  end

  def category_facets
    @serach.facets['categories']['terms'].map(&:values) if @search && @search.facets
  end

  def search_by_term?
    self.q.present?
  end

  private

    # text queries

    def query
      if search_by_term?
        [query_string,query_gtin].reduce(:merge)
      else
        index.all
      end
    end

    def query_string
        index.query( query_string: {
          query: q,
          fields: query_fields,
          analyzer: "german_analyzer",
          default_operator: "and"})
    end

    def query_gtin
      index.query(term: {gtin: {value: q, boost: 100}})
    end

    def query_fields
      fields = [:title,:friendly_percent_organization_nickname]
      fields += [:content] if search_in_content?
      fields
    end

    # filters

    def boolead_filters
      filters = []
      [:fair,:ecologic,:small_and_precious,:swappable,:borrowable].each do |field|
        filters << index.filter(term: {field => true }) if self.send(field)
      end
      filters.reduce(:merge)
    end

    def zip_filter
      index.filter(prefix: {zip: zip }) if zip.present?
    end

    def price_filter
      index.filter(range: {price: price_range })
    end

    def condition_filter
      index.filter(term: {condition: condition}) if condition.present?
    end

    def category_filter
      index.filter(terms: {categories: [category_id]}) if category_id.present?
    end

    # facets
    def category_facet
      index.facets(categories: { terms: { field: :categories, size: 10000}})
      # If we ever hit 10000 categories+ this has to be upgraded
    end

    # sorting

    def sorting
      index.order(SORT[sort])
    end


    # helper methods

    def price_range
      @price_range ||= PriceRangeParser.new(price_from, price_to)
      # set the values for proper formatting
      self.price_from, self.price_to = @price_range.form_values
      {gte: @price_range.from_cents , lte: @price_range.to_cents }
    end



end
