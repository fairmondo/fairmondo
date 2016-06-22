#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibraryPopularitySpawnerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :statistics,
                  retry: 20,
                  backtrace: true

  def perform
    Library.find_each do |library|
      LibraryPopularityWorker.perform_async(library.id)
    end
  end
end
