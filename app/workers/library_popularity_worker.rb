class LibraryPopularityWorker
  include Sidekiq::Worker

  sidekiq_options queue: :statistics,
                  retry: 20,
                  backtrace: true

  def perform library_id
    @library = Library.find(library_id)
    @library.update_column :popularity, popularity
  end

  private

  # Hearts: Extra points for recent hearts
  # Comments: Extra points for recent comments
  def popularity
    # Calculate popularity
    recency_factor * (
      number_of_hearts +
      number_of_recent_hearts + (
        number_of_comments +
        number_of_recent_comments
      ) * 5
    )
  end

  def recency_factor
    # Time since last update
    # Libraries that have been updated recently carry more weight
    case Time.now - @library.updated_at
    when 0.days..3.days then 10
    when 3.days..7.days then 2
    else 1
    end
  end

  %w(hearts comments).each do |type|
    define_method "number_of_#{ type }" do
      @library.send "#{ type }_count"
    end

    define_method "number_of_recent_#{ type }" do
      @library.send(type)
        .where('updated_at > ? AND updated_at < ?', Time.now - 3.days, Time.now)
        .count
    end
  end
end
