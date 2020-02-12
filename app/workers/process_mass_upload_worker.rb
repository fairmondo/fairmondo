#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ProcessMassUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mass_upload,
                  retry: 20,
                  backtrace: true

  def perform mass_upload_id
    mass_upload = MassUpload.find mass_upload_id

    # start spawning
    mass_upload.start
    row_count = 0
    begin
      CSV.foreach(mass_upload.file.path, encoding: MassUploadConcerns::Checks.get_csv_encoding(mass_upload.file.path), col_sep: ';', quote_char: '"', headers: true) do |row|
        row_count += 1
        row.delete '€' # delete encoding column

        if mass_upload.user.heavy_uploader?
          Sidekiq::Client.push('queue' => 'heavy_mass_upload_rows',
                               'class' => ProcessRowMassUploadWorker,
                               'args' => [mass_upload_id, row.to_hash, row_count])
        else
          ProcessRowMassUploadWorker.perform_async(mass_upload_id, row.to_hash, row_count)
        end
      end

      mass_upload.update_attribute(:row_count, row_count)

    rescue ArgumentError
      mass_upload.error(I18n.t('mass_uploads.errors.wrong_encoding'))
    rescue CSV::MalformedCSVError
      mass_upload.error(I18n.t('mass_uploads.errors.illegal_quoting'))
    end
  end
end
