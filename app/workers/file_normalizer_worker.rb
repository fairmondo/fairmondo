class FileNormalizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :file_normalizer,
    retry: 5,
    backtrace: true

  def perform article_id
    article = Article.find article_id

    article.images.each do |image|
      path = "/var/www/fairmondo/shared/#{image.image.path(:cut_here)}"
      index = path.index('cut_here') - 1
      path = path[0..index]
      files = Dir.glob("#{path}*/*")

      files.each do |file|
        File.rename(file, file[0..file.rindex('/')] + Assets::Filename.normalize(file[file.rindex('/') + 1..-1]))
      end
    end
  end
end
