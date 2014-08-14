class LibraryPopularityWorker
  include Sidekiq::Worker

  sidekiq_options queue: :statistics,
                  retry: 20,
                  backtrace: true

  def perform library_id
    library = Library.find(library_id)
    library.update_column :popularity, popularity_for(library)
  end

  def popularity_for library
    # number of hearts in the last 30 days, each heart counts for one popularity point
    popularity = library.hearts.where("updated_at > ? AND updated_at < ?", Time.now - 3.days, Time.now).count
    # number of comments in the last 30 days, each comment counts ten times as much as a heart
    popularity += library.comments.where("updated_at > ? AND updated_at < ?", Time.now - 3.days, Time.now).count * 10
    popularity
  end
end
