#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
