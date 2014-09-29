class FileNormalizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :file_normalizer,
                  retry: 5,
                  backtrace: true

  def perform article_id
    article = Article.find article_id

    article.images.each do |image|
      if image_not_accesible(image)
        path = "var/www/fairnopoly/shared/#{image.path(:cut_here)}"
        index = path.index('cut_here') - 1
        path = path[0..index]
        files = Dir.glob("#{path}*/*")

        files.each do |file|
          file_logger.log(Assets::Filename.normalize(file[file.rindex('/') + 1, file.length]))
          #File.rename(file, Assets::Filename.normalize(file[file.rindex('/') + 1, file.length]))
        end
      end
    end
  end

  def self.file_logger
    Logger.new("#{Rails.root}/log/filerename.log")
  end

  def self.image_not_accesible(image)
    Paperclip.io_adapters.for(image.image).read
    return false
  rescue
    return true
  end
end
