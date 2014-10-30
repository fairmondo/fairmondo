class SearchIndexSpawnerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :indexing,
                  retry: 20, # this means approx 6 days
                  backtrace: true

  def perform article_ids
    article_ids.each do |article_id|
      SearchIndexWorker.perform_async(:article, article_id, :store)
    end
  end
end
