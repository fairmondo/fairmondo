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

  def perform
    BelboonArticleExporter.export
  end
end
