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
                  retry: 20,
                  backtrace: true

  def perform mass_upload_id
    mass_upload = MassUpload.find mass_upload_id

    # start spawning
    mass_upload.start
    row_count = 0
    begin
      CSV.foreach(mass_upload.file.path, encoding: MassUpload::Checks.get_csv_encoding(mass_upload.file.path), col_sep: ';', quote_char: '"', headers: true) do |row|
        row_count += 1
        row.delete '€' # delete encoding column

        ProcessRowMassUploadWorker.perform_async( mass_upload_id, row.to_hash, row_count )

      end

      mass_upload.update_attribute(:row_count, row_count)

    rescue ArgumentError
      mass_upload.error(I18n.t('mass_uploads.errors.wrong_encoding'))
    rescue CSV::MalformedCSVError
      mass_upload.error(I18n.t('mass_uploads.errors.illegal_quoting'))
    end
  end
end
