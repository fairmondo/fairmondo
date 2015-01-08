class BrokenImageFinderWorker
  include Sidekiq::Worker

  sidekiq_options queue: :broken_file_finder,
    retry: 0,
    backtrace: true

  def perform image_id
    path = ArticleImage.select("image_file_name,id").find(image_id).image.path
    unless File.exists? path
      Sidekiq.redis do |redis|
        redis.sadd("broken_image_files",image_id)
      end
    end
  end
end
