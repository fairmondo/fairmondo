class LibraryPopularityWorker
  include Sidekiq::Worker

  sidekiq_options queue: :statistics,
                  retry: 20,
                  backtrace: true

  def perform library_id
    library = Library.find(library_id)
    library.update_column :popularity, popularity_for(library)
  end

  private

  def popularity_for library
    # Hearts: Extra points for recent hearts
    num_hearts = library.hearts_count
    num_recent_hearts = library.hearts.where('updated_at > ? AND updated_at < ?', Time.now - 3.days, Time.now).count
    # Comments: Extra points for recent comments
    num_comments = library.comments_count
    num_recent_comments = library.comments.where('updated_at > ? AND updated_at < ?', Time.now - 3.days, Time.now).count
    # Calculate popularity
    recency_factor_for(library) * (num_hearts + num_recent_hearts + (num_comments + num_recent_comments) * 5)
  end

  def recency_factor_for library
    # Time since last update
    time_since_update = Time.now - library.updated_at
    # Libraries that have been updated recently carry more weight
    case time_since_update
      when 0.days..3.days
        10
      when 3.days..7.days
        2
      else
        1
    end
  end
end
