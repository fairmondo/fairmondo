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
  sidekiq_options queue: :mass_upload_rows,
                  retry: 20,
                  backtrace: true


  sidekiq_retries_exhausted do |msg|
     Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
     mass_upload = MassUpload.find msg['args'].first
     mass_upload_article = mass_upload.mass_upload_articles.where(:row_index => msg['args'].last).first
     ProcessRowMassUploadWorker.add_article_error_messages_to( mass_upload, I18n.t( 'mass_uploads.errors.unknown_error' ), mass_upload_article , msg['args'][1]) if mass_upload_article
     #see method call args order of perform method for msg array explanation
  end

  def perform mass_upload_id, unsanitized_row_hash, index
    mass_upload = MassUpload.find mass_upload_id

    if mass_upload.processing?

      mass_upload_article = mass_upload.mass_upload_articles.where(:row_index => index).first

      # Check the work is already done by a different process
      return if mass_upload_article.present? && mass_upload_article.article.present?

      mass_upload_article = mass_upload.mass_upload_articles.create!(:row_index => index) unless mass_upload_article.present?

      row_hash = sanitize_fields unsanitized_row_hash.dup
      categories = Category.where(:id => row_hash['categories'].split(",").map { |s| s.to_i }) if row_hash['categories']
      row_hash.delete("categories")
      row_hash = MassUpload::Questionnaire.include_fair_questionnaires(row_hash)
      row_hash = MassUpload::Questionnaire.add_commendation(row_hash)

      article = create_or_find_according_to_action row_hash, mass_upload.user

      if article.action != :nothing # so we can ignore rows when reimporting
        article.user_id = mass_upload.user_id
        revise_prices(article)
        article.categories = categories if categories
      end
      if errors_exist_in? article # invalid? call would clear our previous base errors
                                     # fix this by generating the base errors with proper validations
                                     # may be hard for dynamic update model
        ProcessRowMassUploadWorker.add_article_error_messages_to( mass_upload, validation_errors_as_text_for(article), mass_upload_article, unsanitized_row_hash )
      else
        process article, mass_upload_article
      end
    end
  end

  private

    # When an action is set, modify the save call to reflect what should be done
    # @return [Article] Article ready to save or containing an error
    def create_or_find_according_to_action attribute_hash, user
      attribute_hash['action'].strip! if attribute_hash['action']
      case attribute_hash['action']
      when 'c', 'create'
        Article.new attribute_hash.merge({ action: :create })
      when 'u', 'update', 'x', 'delete', 'a', 'activate', 'd', 'deactivate'
        process_dynamic_update attribute_hash, user
      when nil
        attribute_hash['action'] = get_processing_default attribute_hash, user
        create_or_find_according_to_action attribute_hash, user #recursion happens once
      when 'nothing'
        # Keep article as is. We could update it, but this conflicts with locked articles
        article = find_by_id_or_custom_seller_identifier attribute_hash, user
        article.action = :nothing
        article
      else
        create_error_article I18n.t("mass_uploads.errors.unknown_action")
      end
    end

    # We allow sellers to use their custom field as an identifier but we need the ID internally
    def find_by_id_or_custom_seller_identifier attribute_hash, user
      if attribute_hash['id']
        article = user.articles.where(id: attribute_hash['id']).first
      elsif attribute_hash['custom_seller_identifier']
        article = find_article_by_custom_seller_identifier attribute_hash['custom_seller_identifier'], user
      else
        article = create_error_article  I18n.t("mass_uploads.errors.no_identifier")
      end

      unless article
        article = create_error_article  I18n.t("mass_uploads.errors.article_not_found")
      end

      article
    end

    # Process update or state change
    def process_dynamic_update attribute_hash, user
      article = find_by_id_or_custom_seller_identifier attribute_hash, user

      case attribute_hash['action']
      when 'u', 'update'
        article.keep_images = article.business_transactions.empty?
        article = Article.edit_as_new article unless article.preview?
        attribute_hash.delete("id")
        article.attributes = attribute_hash
        article.action = :update
      when 'x', 'delete'
        article.action = :delete
      when 'a', 'activate'
        article.action = :activate
      when 'd', 'deactivate'
        article.action = :deactivate
      end
      article
    end

    # Defaults: create when no ID is set, does nothing when an ID exists
    # @return [String]
    def get_processing_default attribute_hash, user
      if attribute_hash['id']
        'nothing'
      elsif attribute_hash['custom_seller_identifier']
        if find_article_by_custom_seller_identifier(attribute_hash['custom_seller_identifier'], user).present?
          'nothing'
        else
          'create'
        end
      else
        'create'
      end
    end

    # Get article with error message for display in MassUpload#new error list
    # @param error_message [String] Message to display
    # @return [Article] Article containing error field
    def create_error_article error_message
      article = Article.new
      article.errors[:base] = error_message
      article
    end

    def find_article_by_custom_seller_identifier custom_seller_identifier, user
      user.articles.where(custom_seller_identifier: custom_seller_identifier).latest_without_closed.first
    end

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

    def validation_errors_as_text_for article
      validation_errors = ""
      validation_errors += article.errors.full_messages.join("\n")
    end

    # Perform Validations without clearing the base errors on this object.
    # Need this for setting things in create_error_article
    def errors_exist_in? article
      unless article.errors[:base].any? # If there are base errors something went wrong in general and we can skip the other validations
        base_errors = article.errors.dup # save errors before .valid? call because it clears errors
        article.valid? # preform validation
        base_errors.each do |key,error| # readd old error msgs
          article.errors.add(key,error)
        end
      end
      article.errors.any?
    end

    # Replacement for save! method - Does different things based on the action attribute

    def process  article, mass_upload_article
      Article.transaction do
        MassUploadArticle.transaction do
          case article.action
          when :activate, :create, :update
            article.calculate_fees_and_donations
            article.save!
          when :delete
            article.close_without_validation
          when :deactivate
            article.deactivate_without_validation
          end
          mass_upload_article.update_attributes(article: article, action: article.action)
        end
      end
    end

    def self.add_article_error_messages_to( mass_upload, validation_errors, mass_upload_article, row_hash )
      csv = CSV.generate_line(MassUpload.article_attributes.map{ |column| row_hash[column] }, col_sep: ';')
      mass_upload_article.update_attributes!(validation_errors: validation_errors,article_csv: csv)
    end
end
