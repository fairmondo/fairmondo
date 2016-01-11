#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ArticleSearch
  SORT = {
    newest: { created_at: :desc },
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

  # Index

  def index
    ArticlesIndex
  end

  # public api

  def category_facets
    @_category_facets ||= Hash[@search.aggregations['category']['buckets'].map(&:values)] if @search && @search.facets
  end

  def result
    @search
  end

  def self.search query
    instance = new(query)
    instance.build
    instance
  end

  def build
    @search = [
      query,
      boolead_filters,
      zip_filter,
      price_filter,
      category_filter,
      condition_filter,
      category_aggregations,
      sorting
    ].compact.reduce(:merge).query_mode(1)
  end

  private

  def initialize query
    @query = query
  end

  # text queries

  def query
    if @query.search_by_term?
      [query_string, query_gtin].reduce(:merge)
    else
      index.all
    end
  end

  def query_string
    index.query(simple_query_string: {
                  query: @query.q,
                  fields: query_fields,
                  analyzer: 'german_search_analyzer',
                  default_operator: 'and',
                  lenient: true
                })
  end

  def query_gtin
    index.query(term: { gtin: { value: @query.q, boost: 100 } })
  end

  def query_fields
    fields = [:title, :seller_nickname]
    fields += [:content] if @query.search_in_content?
    fields
  end

  # filters

  def boolead_filters
    filters = []
    [:fair, :ecologic, :small_and_precious, :swappable, :borrowable].each do |field|
      filters << index.filter(term: { field => true }) if @query.send(field)
    end
    filters.reduce(:merge)
  end

  def zip_filter
    index.filter(prefix: { zip: @query.zip }) if @query.zip.present?
  end

  def price_filter
    index.filter(range: { price: @query.price_range })
  end

  def condition_filter
    index.filter(term: { condition: @query.condition }) if @query.condition.present?
  end

  def category_filter
    index.filter(terms: { categories: [@query.category_id] }) if @query.category_id.present?
  end

  # facets
  def category_aggregations
    index.aggregations(category: { terms: { field: :categories, size: 10000 } })
  end

  # sorting
  def sorting
    order = @query.order_by
    order = @query.search_by_term? ? 'relevance' : 'newest' unless order
    index.order(SORT[order])
  end
end
