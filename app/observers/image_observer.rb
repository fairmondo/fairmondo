#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ImageObserver < ActiveRecord::Observer
  def after_save(image)
    # Save path to new images in text file for backup purpose
    image.write_path_to_file_for('additions')
  end
end
