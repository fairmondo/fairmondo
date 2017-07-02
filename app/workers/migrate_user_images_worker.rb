#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class MigrateUserImagesWorker
  include Sidekiq::Worker

  def perform
    UserImage.find_each do |user_image|
      MigrateUserImageWorker.perform_async user_image.id
    end
  end
end
