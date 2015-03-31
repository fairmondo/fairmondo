class BelboonArticleExporterWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrance { weekly.day_of_week(1).hour_of_day(2) }

  sidekiq_options queue: :sidekiq_pro,
                  retry: 5,
                  backtrace: true

  IDS = [1020]

  def perform
    IDS.each do |id|
      user = User.find id
      BelboonArticleExporter.export(user)
    end
  end
end
