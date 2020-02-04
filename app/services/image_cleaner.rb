#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ImageCleaner
  def initialize
  end

  def show(range)
    files_found = 0

    File.open('image_cleaner.txt', 'w') do |file|
      for id in range
        path = path(id)

        begin
          img = Image.find(id)
          file.puts("#{id}: #{img.image_file_name}")
        rescue ActiveRecord::RecordNotFound
          if File.exist?(path)
            files_found += 1
            file.puts("#{id}: no image")
          end
        end
      end

      file.puts("Extranous files total: #{files_found}")
    end
  end

  def path(id)
    id_str = padded_id(id)
    Rails.root.join('public', 'system', 'images', id_str[0..2], id_str[3..5], id_str[6..8])
  end

  def padded_id(id)
    sprintf('%09d', id)
  end
end
