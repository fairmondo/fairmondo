#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class MigrateUserImageWorker
  include Sidekiq::Worker

  def perform user_image_id
    user_image = UserImage.find(user_image_id)
    user_image.copy_to_gcs if user_image.image
  end
end
