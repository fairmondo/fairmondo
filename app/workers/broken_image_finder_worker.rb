#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BrokenImageFinderWorker
  include Sidekiq::Worker

  sidekiq_options queue: :broken_file_finder,
                  retry: 0,
                  backtrace: true

  def perform image_id
    path = ArticleImage.select('image_file_name,id').find(image_id).image.path
    unless File.exist? path
      Sidekiq.redis do |redis|
        redis.sadd('broken_image_files', image_id)
      end
    end
  end
end
