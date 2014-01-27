# encoding: UTF-8
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class ProcessMassUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mass_upload,
                  retry: 5,
                  backtrace: true

  sidekiq_options :failures => true

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform mass_upload_id
    mass_upload = MassUpload.find mass_upload_id
    mass_upload.start
    stored_row_count = Redis.current.get("mass_upload#{mass_upload_id}_row_count").to_i
    row_count = 0
    begin
      CSV.foreach(mass_upload.file.path, encoding: MassUpload::Checks.get_csv_encoding(mass_upload.file.path), col_sep: ';', quote_char: '"', headers: true) do |row|
        row_count += 1
        unless stored_row_count && row_count < stored_row_count
          row.delete '€' # delete encoding column
          ProcessRowMassUploadWorker.perform_async(mass_upload_id, row.to_hash, row_count)
        end
      end

      mass_upload.update_attribute(:row_count, row_count)

    rescue ArgumentError
      mass_upload.error(I18n.t('mass_uploads.errors.wrong_encoding'))
    rescue CSV::MalformedCSVError
      mass_upload.error(I18n.t('mass_uploads.errors.illegal_quoting'))
    ensure
      Redis.current.set("mass_upload#{mass_upload_id}_row_count", row_count)
    end
  end
end