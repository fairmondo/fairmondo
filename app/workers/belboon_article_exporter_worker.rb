class BelboonArticleExporterWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence  do
    if Rails.env == 'production'
      weekly.day(1).hour_of_day(2)
    end
  end

  sidekiq_options queue: :belboon_csv_export,
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
