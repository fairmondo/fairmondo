class ImageObserver < ActiveRecord::Observer

  def after_save(image)
    # Save path to new images in text file for backup purpose
    image.write_path_to_file_for('additions')
  end

end
