#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class ProcessRowMassUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mass_upload_rows,
                  retry: 20,
                  backtrace: true

  sidekiq_retries_exhausted do |msg|
     Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
     mass_upload = MassUpload.find msg['args'].first
     mass_upload_article = mass_upload.mass_upload_articles.where(row_index: msg['args'].last).first
     mass_upload_article.update_attributes(action: :error, validation_errors: msg['args'][1]) if mass_upload_article
     #see method call args order of perform method for msg array explanation
  end

  def perform mass_upload_id, unsanitized_row_hash, index
    mass_upload = MassUpload.find mass_upload_id
    if mass_upload.processing?
      mass_upload_article = MassUploadArticle.find_or_create_from_row_index index, mass_upload
      return if mass_upload_article.done?
      mass_upload_article.process unsanitized_row_hash
    end
  end
end
