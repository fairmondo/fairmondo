#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class MassUploadsFinishWorker
  include Sidekiq::Worker

  sidekiq_options queue: :mass_uploads_finish,
                  retry: 20,
                  backtrace: true

  def perform
    MassUpload.processing.each do |mass_upload|
      mass_upload.finish
    end
  end
end
