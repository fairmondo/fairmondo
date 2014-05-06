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

    # we need to be careful if there are already some mass_upload_articles
    careful = mass_upload.mass_upload_articles.any? ? true : false

    # start spawning
    mass_upload.start
    row_count = 0
    begin
      CSV.foreach(mass_upload.file.path, encoding: MassUpload::Checks.get_csv_encoding(mass_upload.file.path), col_sep: ';', quote_char: '"', headers: true) do |row|
        row_count += 1
        row.delete '€' # delete encoding column

        # if we are careful we want to grab the mass_upload_articles
        mass_upload_article = careful ? mass_upload.mass_upload_articles.where(:row_index => row_count).first : nil

        # if we have a mass_upload_article and its worker process is still running or already done then we skip this
        unless mass_upload_article.present? && mass_upload_article.still_working_or_done?
          process_identifier = SecureRandom.hex(12)
          mass_upload.mass_upload_articles.create!(:row_index => row_count, :process_identifier => process_identifier)
          Sidekiq::Client.push({ 'class' => ProcessRowMassUploadWorker ,'args'  => [mass_upload_id, row.to_hash, row_count] , 'jid' => process_identifier})
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
