#
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
class ProcessRowMassUploadWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mass_upload,
                  retry: 5,
                  backtrace: true

  def perform mass_upload_id, unsanitized_row_hash, index
    all_time = Benchmark.ms do
    mass_upload = MassUpload.find mass_upload_id

    if mass_upload.processing?
      row_hash = sanitize_fields unsanitized_row_hash.dup
      categories = Category.find_imported_categories(row_hash['categories'])
      row_hash.delete("categories")
      row_hash = MassUpload::Questionnaire.include_fair_questionnaires(row_hash)
      row_hash = MassUpload::Questionnaire.add_commendation(row_hash)

      article = Article.create_or_find_according_to_action row_hash, mass_upload.user

      if article.action != :nothing # so we can ignore rows when reimporting
        article.user_id = mass_upload.user_id
        revise_prices(article)
        article.categories = categories if categories
      end
      if article.was_invalid_before? # invalid? call would clear our previous base errors
                                     # fix this by generating the base errors with proper validations
                                     # may be hard for dynamic update model
        mass_upload.add_article_error_messages(article, index, unsanitized_row_hash)
      else
        article.process! mass_upload
      end
    end

    mass_upload.finish
    end

  end

  private
   # Throw away additional fields that are not needed
    def sanitize_fields row_hash
      row_hash.keys.each do |key|
        row_hash.delete key unless MassUpload.article_attributes.include? key
      end
      row_hash
    end

   def revise_prices(article)
    article.basic_price ||= 0
    article.transport_type1_price_cents ||= 0
    article.transport_type2_price_cents ||= 0
    article.payment_cash_on_delivery_price_cents ||= 0
  end

end