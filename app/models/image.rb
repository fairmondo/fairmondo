#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Image < ActiveRecord::Base
  include ::Assets::Normalizer

  def self.reprocess image_id, style = :thumb
    Image.find(image_id).image.reprocess! style
  end

  def write_path_to_file_for(type)
    if Rails.env == 'production'
      arr = []
      File.open("/var/www/fairnopoly/shared/backup_info/#{type}_#{Time.now.strftime('%Y_%m_%d')}", 'a') do |file|
        self.image.styles.each_key do |style|
          unless arr.include?(style)
            file.write(self.image.path(style) + "\n")
            arr << style
          end
        end
      end
    end
    true
  end
end
