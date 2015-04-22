# Oct 31 (Spooky Bug) - The original file_normalizer_worker didn't account for
# old image paths sometimes having two images in there. It just took the first
# one, but we actually need the youngest (by system change time) to become the
# main image.
class FileFixerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :file_normalizer,
                  retry: 5,
                  backtrace: true

  def perform image_id
    image = Image.find(image_id)

    # get the path to the image
    path = "/var/www/fairnopoly/shared/#{image.image.path}"
    path = path[0..path.rindex('/')] #=> .../original/

    # get the paths to the image files in the style directories
    files = Dir.glob("#{path}*")

    if files.count > 1 # if there is a conflict
      # check which is the most recently updated
      mod_times = files.map { |file| File.mtime(file).to_i }

      newest_filepath = mod_times.zip(files).max[1]
      newest_filename = newest_filepath[newest_filepath.rindex('/') + 1..-1]

      unless image.image_file_name == newest_filename
        image.update_column :image_file_name, newest_filename

        # index changed articles
        Indexer.index_article(image.article)
      end
    end
  end
end
