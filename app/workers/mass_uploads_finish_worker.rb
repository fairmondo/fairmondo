#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class MassUploadsFinishWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mass_uploads_finish,
                  retry: 20,
                  backtrace: true

  include Sidetiq::Schedulable

  recurrence do
    hourly.minute_of_hour(*((0..5).to_a.map { |d| d * 10 }))
  end

  def perform
    MassUpload.processing.each do |mass_upload|
      mass_upload.finish
    end
  end
end
