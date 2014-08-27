class LibraryPopularitySpawnerWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  sidekiq_options queue: :statistics,
                  retry: 20,
                  backtrace: true

  def perform
    Library.find_each do |library|
      LibraryPopularityWorker.perform_async(library.id)
    end
  end
end
