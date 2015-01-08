class SearchIndexWorker
  include Sidekiq::Worker

  sidekiq_options queue: :indexing,
                  retry: 20, # this means approx 6 days
                  backtrace: true

  def perform type, ids

    type = case type.to_sym
    when :article
      ArticlesIndex::Article
    end

    type.import! ids, batch_size: 100

  end
end
