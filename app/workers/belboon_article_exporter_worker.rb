#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BelboonArticleExporterWorker
  include Sidekiq::Worker

  sidekiq_options queue: :belboon_csv_export,
                  retry: 5,
                  backtrace: true

  def perform
    BelboonArticleExporter.export
  end
end
