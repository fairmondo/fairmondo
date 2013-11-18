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
class MassUpload

  # Required for Active Model Conversion which is required by Formtastic
  include ActiveModel::Conversion

  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  include Checks, Questionnaire, FeesAndDonations

  def self.mass_upload_attrs
    [:file]
  end

  def self.header_row
   ["€", "id", "title", "categories", "condition", "condition_extra",
    "content", "quantity", "price_cents", "basic_price_cents",
    "basic_price_amount", "vat", "external_title_image_url", "image_2_url",
    "transport_pickup", "transport_type1",
    "transport_type1_provider", "transport_type1_price_cents",
    "transport_type2", "transport_type2_provider",
    "transport_type2_price_cents", "transport_details",
    "payment_bank_transfer", "payment_cash", "payment_paypal",
    "payment_cash_on_delivery",
    "payment_cash_on_delivery_price_cents", "payment_invoice",
    "payment_details", "fair_kind", "fair_seal", "support",
    "support_checkboxes", "support_other", "support_explanation",
    "labor_conditions", "labor_conditions_checkboxes",
    "labor_conditions_other", "labor_conditions_explanation",
    "environment_protection", "environment_protection_checkboxes",
    "environment_protection_other",
    "environment_protection_explanation", "controlling",
    "controlling_checkboxes", "controlling_other",
    "controlling_explanation", "awareness_raising",
    "awareness_raising_checkboxes", "awareness_raising_other",
    "awareness_raising_explanation", "nonprofit_association",
    "nonprofit_association_checkboxes",
    "social_businesses_muhammad_yunus",
    "social_businesses_muhammad_yunus_checkboxes",
    "social_entrepreneur", "social_entrepreneur_checkboxes",
    "social_entrepreneur_explanation", "ecologic_seal",
    "upcycling_reason", "small_and_precious_eu_small_enterprise",
    "small_and_precious_reason", "small_and_precious_handmade",
    "gtin", "custom_seller_identifier", "action"]
  end

  # Gives header row that is needed for updates and deletes
  # def self.expanded_header_row
  #   ['id'] + header_row + ['action']
  # end

  # Provide basic hash that gets filled in the controller with article IDs
  # @return [Hash]
  def self.prepare_session_hash
    Hash[ Article.actions.map { |action| [action, []] } ]
  end
  # Compile a list of articles in a hash; keys indicate what has been done with them
  def self.compile_report_for session_hash
    Hash[
      Article.actions.map do |action|
        [action, Article.find_all_by_id(session_hash[action]).sort_by(&:created_at)]
      end
    ]
  end

  def initialize(attributes = nil)
    @errors = ActiveModel::Errors.new(self)

    if attributes && attributes[:file]
      self.file = attributes[:file]
    end
  end

  attr_accessor :file
  attr_reader   :errors, :articles

  def parse_csv_for user

    unless file_selected?
      return false
    end

    unless csv_format?
      return false
    end

    unless open_csv
      return false
    end

    unless correct_article_count?
      return false
    end

    #unless correct_header?
    #  return false
    #end

    unless build_articles_for user
      return false
    end

    save_articles!

    true
  end

  def build_articles_for user
    @articles = []
    valid = true

    @csv.each_with_index do |row,index|
      row_hash = sanitize_fields row.to_hash
      categories = Category.find_imported_categories(row_hash['categories'])
      row_hash.delete("categories")
      row_hash = Questionnaire.include_fair_questionnaires(row_hash)
      row_hash = Questionnaire.add_commendation(row_hash)
      article = Article.create_or_find_according_to_action row_hash, user

      if article # so we can ignore rows when reimporting
        article.user_id = user.id
        revise_prices(article)
        article.categories = categories if categories
        if article.was_invalid_before? # invalid? call would clear our previous base errors
                                       # fix this by generating the base errors with proper validations
                                       # may be hard for dynamic update model
          add_article_error_messages(article, index)
          valid = false
        end
        @articles << article
      end
    end
    return valid
  end

  def add_article_error_messages(article, index)
    # TODO Needs refactoring (the error messages should be styled elsewhere -> no <br>s)
    article.errors.full_messages.each do |message|
      first_line_break = ""
      if article.errors.full_messages[0] == message && index > 0
        first_line_break = "<br/>"
      end
      errors.add(:file, "<br/>#{first_line_break} #{I18n.t('mass_uploads.errors.wrong_article', message: message, index: (index + 2))}")
    end
  end

  def save_articles!
    @articles.each do |article|
      article.calculate_fees_and_donations
      article.process!
      article.extract_external_image!
    end
  end

  def revise_prices(article)
    article.basic_price ||= 0
    article.transport_type1_price_cents ||= 0
    article.transport_type2_price_cents ||= 0
    article.payment_cash_on_delivery_price_cents ||= 0
  end

  # The following 3 methods are needed for Active Model Errors

  # def MassUpload.human_attribute_name(attr, options = {})
  #  attr
  # end

  # The following 2 are not currently used but might be needed because of Active
  # Model Errors in the future. They are commented out to make sure the test
  # coverage can reach 100%
  # def read_attribute_for_validation(attr)
  #  send(attr)
  # end

  # def MassUpload.lookup_ancestors
  #  [self]
  # end

  # The following method is needed for Active Model Conversions
  def persisted?
    false
  end

  private
    # Throw away additional fields that are not needed
    def sanitize_fields row_hash
      row_hash.keys.each do |key|
        row_hash.delete key unless MassUpload.header_row.include? key
      end
      row_hash
    end
end