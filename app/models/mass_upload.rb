# encoding: utf-8
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class MassUpload

  # Required for Active Model Conversion which is required by Formtastic
  include ActiveModel::Conversion

  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  def initialize(user, attributes = nil)
    @errors = ActiveModel::Errors.new(self)
    # To check if there are attributes at all (for rendering the new view) and
    # to check if any file was selected
    if attributes && attributes[:file]
      @raw_articles = build_raw_articles(user, attributes[:file])
    end
  end

  attr_accessor :file
  attr_reader   :errors, :raw_articles

  def validate_input(file)
    # Needed for the 'stand alone' validation since we don't know if
    # params[:mass_upload] == nil or not and therefore can't use
    # params[:mass_upload][:file]
    if file.class == ActiveSupport::HashWithIndifferentAccess
      file = file[:file]
    end

    unless csv_format?(file)
      errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
      return false
    end

    begin
      CSV.read(file.path, :encoding => 'utf-8')
    rescue ArgumentError
      errors.add(:file, I18n.t('mass_upload.errors.wrong_encoding'))
      return false
    rescue CSV::MalformedCSVError
      errors.add(:file, I18n.t('mass_upload.errors.illegal_quoting'))
      return false
    end

    unless correct_file_size?(file)
      errors.add(:file, I18n.t('mass_upload.errors.wrong_file_size'))
      return false
    end

    unless correct_header?(file)
      errors.add(:file, I18n.t('mass_upload.errors.wrong_header'))
      return false
    end
    true
  end

  def validate_articles(articles)
    # bugbugb Needs refactoring (the error messages should be styled elsewhere -> no <br>s)
    valid = true
    raw_articles.each_with_index do |raw_article, index|
      unless raw_article.valid?
        raw_article.errors.full_messages.each do |message|
          if raw_article.errors.full_messages[0] == message && index > 0
            errors.add(:file, "<br><br> #{I18n.t('mass_upload.errors.wrong_article', message: message, index: (index + 2))}")
          else
            errors.add(:file, "<br> #{I18n.t('mass_upload.errors.wrong_article', message: message, index: (index + 2))}")
          end
        end
        valid = false
      end
    end
    valid
  end

  def csv_format?(file)
    file && file.content_type == "text/csv" ? true : false
  end

  def correct_header?(file)
    header_row = ["title;categories;condition;condition_extra;content;quantity;price_cents;basic_price_cents;basic_price_amount;vat;title_image_url;image_2_url;transport_pickup;transport_type1;transport_type1_provider;transport_type1_price_cents;transport_type2;transport_type2_provider;transport_type2_price_cents;transport_details;payment_bank_transfer;payment_cash;payment_paypal;payment_cash_on_delivery;payment_cash_on_delivery_price_cents;payment_invoice;payment_details;fair_kind;fair_seal;support;support_checkboxes;support_other;support_explanation;labor_conditions;labor_conditions_checkboxes;labor_conditions_other;labor_conditions_explanation;environment_protection;environment_protection_checkboxes;environment_protection_other;environment_protection_explanation;controlling;controlling_checkboxes;controlling_other;controlling_explanation;awareness_raising;awareness_raising_checkboxes;awareness_raising_other;awareness_raising_explanation;nonprofit_association;nonprofit_association_checkboxes;social_businesses_muhammad_yunus;social_businesses_muhammad_yunus_checkboxes;social_entrepreneur;social_entrepreneur_checkboxes;social_entrepreneur_explanation;ecologic_seal;upcycling_reason;small_and_precious_eu_small_enterprise;small_and_precious_reason;small_and_precious_handmade;gtin;custom_seller_identifier"]

    CSV.foreach(file.path, headers: false) do |row|
      if row == header_row
        return true
      else
        return false
      end
    end
  end

  def correct_file_size?(file)
    if CSV.read(file.path).size < 102
      return true
    else
      return false
    end
  end

  def missing_bank_details_errors?
    self.errors[:file].grep(/Payment bank transfer/).any? || self.errors[:file].grep(/Payment paypal/).any?
  end

  def add_missing_bank_details_errors_notice
    if self.errors[:file].grep(/Payment bank transfer/).any? && self.errors[:file].grep(/Payment paypal/).any?
      error_message = I18n.t('mass_upload.errors.missing_payment_details',
                        link: '#payment_step',
                        missing_payment: I18n.t('formtastic.labels.user.paypal_and_bank_account'))
    elsif self.errors[:file].grep(/Payment bank transfer/).any?
      error_message = I18n.t('mass_upload.errors.missing_payment_details',
                        link: '#payment_step',
                        missing_payment: I18n.t('formtastic.labels.user.bank_account'))
    elsif self.errors[:file].grep(/Payment paypal/).any?
      error_message = I18n.t('mass_upload.errors.missing_payment_details',
                        link: '#payment_step',
                        missing_payment: I18n.t('formtastic.labels.user.paypal_account'))
    end
  end

  def build_raw_articles(user, file)

    if validate_input(file)
      raw_article_array = []
      rows_array = []
      user_id = user.id
      CSV.foreach(file.path, headers: true, col_sep: ";") do |row|
        rows_array << row.to_hash
      end

      rows_array.each do |row|
        categories = Category.find_imported_categories(row['categories'])
        row.delete("categories")
        row = include_fair_social_questionnaires(row)
        article = Article.new(row)
        article.user_id = user_id
        article.currency = "EUR"
        check_commendation(article)
        revise_prices(article)
        article.categories = categories if categories
        raw_article_array << article
      end
    end
    raw_article_array
  end

  def save
    if validate_articles(raw_articles)
      raw_articles.each do |raw_article|
        raw_article.calculate_fees_and_donations
        raw_article.save
      end
    end
  end

  def self.calculate_total_fees(articles)
    total_fee = Money.new(0)
    articles.each do |article|
      total_fee += article.calculated_fee * article.quantity
    end
    total_fee
  end

  def self.calculate_total_fair(articles)
    total_fair = Money.new(0)
    articles.each do |article|
      total_fair += article.calculated_fair * article.quantity
    end
    total_fair
  end

  def self.calculate_total_fees_and_donations(articles)
    self.calculate_total_fees(articles) + self.calculate_total_fair(articles)
  end

  def self.calculate_total_fees_and_donations_netto(articles)
    total_netto = Money.new(0)
    articles.each do |article|
      total_netto += article.calculated_fees_and_donations_netto_with_quantity
    end
    total_netto
  end

  def include_fair_social_questionnaires(row)
    # bugbug Refactor asap
    row = row.to_a
    fair_trust_questionnaire_attributes_array = row[28..47]
    social_producer_questionnaire_attributes_array = row[48..54]
    fair_trust_questionnaire_attributes = {}
    social_producer_questionnaire_attributes = {}
    row = row - fair_trust_questionnaire_attributes_array - social_producer_questionnaire_attributes_array
    if row[26][1] == "fair_trust"
      key = "fair_trust_questionnaire_attributes"
      row = inject_questionnaire(fair_trust_questionnaire_attributes_array, fair_trust_questionnaire_attributes, row, key)
    elsif row[26][1] == "social_producer"
      key = "social_producer_questionnaire_attributes"
      row = inject_questionnaire(social_producer_questionnaire_attributes_array, social_producer_questionnaire_attributes, row, key)
    else
      row = Hash[row]
    end
    row
  end

  def inject_questionnaire (attributes_array, attributes_hash, row, key)
    attributes_array.each do |pair|
      if pair[0].include?("checkboxes") && pair[1..-1].first && pair[1..-1].first.split(',').length == 1
        attributes_hash[pair.first] = [""] + pair[1].split
      elsif pair[1..-1].first && pair[1..-1].first.split(',').length > 1
        attributes_hash[pair.first] = [""] + pair[1..-1].join.delete(' ').split(',')
      else
        attributes_hash[pair.first] = pair[1..-1].first
      end
    end
    row = Hash[row]
    row[key] = attributes_hash
    row
  end

  def check_commendation(article)
    if article.fair_kind
      article.fair = true
    end
    if article.ecologic_seal
      article.ecologic = true
      article.ecologic_kind = "ecologic_seal"
    elsif article.upcycling_reason
      article.ecologic = true
      article.ecologic_kind = "upcycling"
    end
    if article.small_and_precious_eu_small_enterprise
      article.small_and_precious = true
    end
  end

  def revise_prices(article)
    unless article.basic_price
      article.basic_price = 0
    end
    unless article.transport_type1_price_cents
      article.transport_type1_price_cents = 0
    end
    unless article.transport_type2_price_cents
      article.transport_type2_price_cents = 0
    end
    unless article.payment_cash_on_delivery_price_cents
      article.payment_cash_on_delivery_price_cents = 0
    end
  end

  # The following 3 methods are needed for Active Model Errors

  def MassUpload.human_attribute_name(attr, options = {})
   attr
  end

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

end