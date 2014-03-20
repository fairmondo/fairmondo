class SearchIndexWorker
  include Sidekiq::Worker

  sidekiq_options queue: :indexing,
                  retry: 20, # this means approx 6 days
                  backtrace: true,
                  failures: true
  def perform type, id, action
    type = case type
    when :article
      Article
    end

    item = type.find id

    case action
    when :store
      type.index.store item
    when :delete
      type.index.remove item
    end

  rescue ActiveRecord::RecordNotFound
    # May be deleted yet
  end
end
