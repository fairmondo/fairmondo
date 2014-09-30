class FileNormalizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :file_normalizer,
    retry: 5,
    backtrace: true

  def perform article_id
    article = Article.find article_id

    unless article.title_image_present?
      article.images.each do |image|
        # get the path to the image
        path = "/var/www/fairnopoly/shared/#{image.image.path(:cut_here)}"

        # get the filename of the image as referenced in image object
        orig_filename = path[rindex('/') + 1..-1]

        # get the base directory before the style directories
        index = path.index('cut_here') - 1
        path = path[0..index]

        # get the paths to the image files in the style directories
        files = Dir.glob("#{path}*/*")

        files.each do |file|
          File.rename(file, file[0..file.rindex('/')] + orig_filename)
        end
      end
    end
  end
end
