class ImageObserver < ActiveRecord::Observer

  # Save path to new images in text file for backup purpose
  def after_save(image)
    if Rails.env == 'production'
      arr = []
      File.open("/var/www/fairnopoly/shared/backup_info/images_#{Time.now.strftime('%Y_%m_%d')}", 'a') do |file|
        image.image.styles.each_key do |style|
          unless arr.include?(style)
            file.write(image.image.path(style) + "\n")
            arr << style
          end
        end
      end
    end
  end

end
