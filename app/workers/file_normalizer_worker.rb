class FileNormalizerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :file_normalizer,
    retry: 5,
    backtrace: true

  def perform article_id
    article = Article.unscoped.find article_id

    unless article.title_image_present?
      article.images.each do |image|
        # get the path to the image
        path = "/var/www/fairmondo/shared/#{image.image.path(:cut_here)}"

        # get the filename of the image as referenced in image object
        orig_filename = path[path.rindex('/') + 1..-1]

        # get the base directory before the style directories
        index = path.index('cut_here') - 1
        path = path[0..index]

        # get the paths to the image files in the style directories
        files = Dir.glob("#{path}*/*")

        # write the image path to deletions list
        image.write_path_to_file_for('deletions')

        files.each do |file|
          File.rename(file, file[0..file.rindex('/')] + orig_filename)
        end
        # index changed articles
        Indexer.index_article(article)

        # write image path to additions list
        image.write_path_to_file_for('additions')
      end
    end
  end
end
