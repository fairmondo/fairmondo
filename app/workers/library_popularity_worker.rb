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
    # calculate stuff on library
    rand
  end
end
