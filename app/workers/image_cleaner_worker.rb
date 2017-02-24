#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ImageCleanerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default,
                  retry: 20,
                  backtrace: true

  def perform(first, last)
    cleaner = ImageCleaner.new
    cleaner.show(first..last)
  end
end
