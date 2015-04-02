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

  begin
    IDS = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'belboon_trackable_users.yml'))))[:belboon][:users]
  rescue
    puts 'belboon_trackable_users.yml not found'
  end

  def perform
    IDS.each do |id|
      user = User.find id
      BelboonArticleExporter.export(user)
    end
  end
end
