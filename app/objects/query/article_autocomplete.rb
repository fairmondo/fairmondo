class ArticleAutocomplete
  include Rails.application.routes.url_helpers
  LIMIT = 5

  def initialize query
    @query = query
  end

  def autocomplete
    suggestions = @query.present? ? format(build) : []
    { query: @query, suggestions: suggestions }
  end

  private

  # ES Queries

  def index
    ArticlesIndex
  end

  def build
    [suggest, prefix_query].compact.reduce(:merge) if @query.present?
  end

  def prefix_query
    index.query(prefix: { title: @query }).limit(LIMIT)
  end

  def suggest
    index.suggest(typos:
                    { text: @query,
                      term:
                        { field: :title,
                          suggest_mode: 'popular',
                          sort: 'frequency',
                          analyzer: :simple,
                          size: 3
                        }
                    })
  end

  # output format

  def format results
    formatted_suggestions(results) + formatted_results(results) + formatted_total(results)
  end

  def formatted_results results
    results.map do |result|
      { value: result.title,
        data: {
          type: :result,
          url: article_path(result.slug),
          thumb: ActionController::Base.helpers.image_tag(result.title_image_url_thumb)
        }
      }
    end
  end

  def formatted_suggestions results
    results.suggest['typos'].first['options'].map { |o| { value: o['text'], data: { type: :suggest } } }
  rescue
    []
  end

  def formatted_total results
    total = results.total_count
    total > LIMIT ? [{ value: @query, data: { type: :more, count: total } }] : []
  end
end
