#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
    # see method call args order of perform method for msg array explanation
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
