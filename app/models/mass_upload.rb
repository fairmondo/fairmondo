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

  ARTICLE_COUNT_MAX = 100

  # Required for Active Model Conversion which is required by Formtastic
  include ActiveModel::Conversion

  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  def initialize(attributes = nil)
    @errors = ActiveModel::Errors.new(self)
    # To check if there are attributes at all (for rendering the new view) and
    # to check if any file was selected
    # if create_method == true && attributes == nil
    #   errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
    if attributes && attributes[:file]
      self.file = attributes[:file]
      # @raw_articles = build_raw_articles(user, attributes[:file])
    end
  end

  attr_accessor :file
  attr_reader   :errors, :articles

  def parse_csv_for(user)
    # Needed for the 'stand alone' validation since we don't know if
    # params[:mass_upload] == nil or not and therefore can't use
    # params[:mass_upload][:file]

    # bugbugb Isn't possible to check if params[:mass_upload] == nil before
    # if file.class == ActiveSupport::HashWithIndifferentAccess
    #   file = file[:file]
    # end

    unless file_selected?
      return false
    end

    unless csv_format?
      return false
    end

    unless correct_encoding_and_escaping?
      return false
    end

    unless correct_article_count?
      return false
    end

    unless correct_header?
      return false
    end

    build_articles_for(user)

    unless articles_valid?
      return false
    end

    save_articles!

    true
  end



  def csv_format?
    unless self.file.content_type == "text/csv"
      errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
      return false
    end
    true
  end

  def correct_encoding_and_escaping?
    begin
      CSV.read(self.file.path, :encoding => 'utf-8', :col_sep => ";", :quote_char => '"')
    rescue ArgumentError
      errors.add(:file, I18n.t('mass_upload.errors.wrong_encoding'))
      return false
    rescue CSV::MalformedCSVError
      errors.add(:file, I18n.t('mass_upload.errors.illegal_quoting'))
      return false
    end
    true
  end

  # bugbug Not needed if we test the existence of the file in the initializer with the create_method variable
   def file_selected?
    unless self.file
      errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
      return false
    end
    true
  end

  # def self.file_selected?(file)
  #   mass_upload = MassUpload.new
  #   unless file
  #     mass_upload.errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
  #   end
  #   mass_upload
  # end

  def correct_header?
    # bugbug article.attr-array - was halt nicht dazu gehört
    header_row = "title;categories;condition;condition_extra;content;quantity;price_cents;basic_price_cents;basic_price_amount;vat;external_title_image_url;image_2_url;transport_pickup;transport_type1;transport_type1_provider;transport_type1_price_cents;transport_type2;transport_type2_provider;transport_type2_price_cents;transport_details;payment_bank_transfer;payment_cash;payment_paypal;payment_cash_on_delivery;payment_cash_on_delivery_price_cents;payment_invoice;payment_details;fair_kind;fair_seal;support;support_checkboxes;support_other;support_explanation;labor_conditions;labor_conditions_checkboxes;labor_conditions_other;labor_conditions_explanation;environment_protection;environment_protection_checkboxes;environment_protection_other;environment_protection_explanation;controlling;controlling_checkboxes;controlling_other;controlling_explanation;awareness_raising;awareness_raising_checkboxes;awareness_raising_other;awareness_raising_explanation;nonprofit_association;nonprofit_association_checkboxes;social_businesses_muhammad_yunus;social_businesses_muhammad_yunus_checkboxes;social_entrepreneur;social_entrepreneur_checkboxes;social_entrepreneur_explanation;ecologic_seal;upcycling_reason;small_and_precious_eu_small_enterprise;small_and_precious_reason;small_and_precious_handmade;gtin;custom_seller_identifier\n"

    file = File.new(self.file.path, "r")
    line = file.gets
    unless line == header_row
      errors.add(:file, I18n.t('mass_upload.errors.wrong_header'))
      return false
    end
    true
  end

  def correct_article_count?
    unless CSV.read(self.file.path, :col_sep => ";", :quote_char => '"').size <= (ARTICLE_COUNT_MAX + 1)
      errors.add(:file, I18n.t('mass_upload.errors.wrong_file_size'))
      return false
    end
    true
  end

  # def missing_bank_details_errors?
  #   self.errors[:file].grep(/Payment bank transfer/).any? || self.errors[:file].grep(/Payment paypal/).any?
  # end

  # def add_missing_bank_details_errors_notice
  #   if self.errors[:file].grep(/Payment bank transfer/).any? && self.errors[:file].grep(/Payment paypal/).any?
  #     error_message = I18n.t('mass_upload.errors.missing_payment_details',
  #                       link: '#payment_step',
  #                       missing_payment: I18n.t('formtastic.labels.user.paypal_and_bank_account'))
  #   elsif self.errors[:file].grep(/Payment bank transfer/).any?
  #     error_message = I18n.t('mass_upload.errors.missing_payment_details',
  #                       link: '#payment_step',
  #                       missing_payment: I18n.t('formtastic.labels.user.bank_account'))
  #   elsif self.errors[:file].grep(/Payment paypal/).any?
  #     error_message = I18n.t('mass_upload.errors.missing_payment_details',
  #                       link: '#payment_step',
  #                       missing_payment: I18n.t('formtastic.labels.user.paypal_account'))
  #   end
  # end

  def build_articles_for(user)
    # bugbubg checken ob die funktion noch aufgeteilt werden kann
    @articles = []
    CSV.foreach(self.file.path, headers: true, col_sep: ";") do |row|
      row_hash = row.to_hash
      categories = Category.find_imported_categories(row_hash['categories'])
      row_hash.delete("categories")
      row_hash = include_fair_social_questionnaires(row_hash)
      article = Article.new(row_hash)
      article.user_id = user.id
      add_commendation(article)
      revise_prices(article)
      article.categories = categories if categories
      @articles << article
    end
  end

  def articles_valid?
    valid = true
    @articles.each_with_index do |article, index|
      # bugbug check if this does anything
      # image_errors = false

      if article.errors.full_messages.any?
        add_article_error_messages(article, index)
        valid = false
      end

      if article.invalid?
        add_article_error_messages(article, index)
        valid = false
      end
    end
    return valid
  end

  def add_article_error_messages(article, index)
    # bugbugb Needs refactoring (the error messages should be styled elsewhere -> no <br>s)
    article.errors.full_messages.each do |message|
      first_line_break = ""
      if article.errors.full_messages[0] == message && index > 0 # && image_errors == false
        first_line_break = "<br/>"
      end
      errors.add(:file, "<br/>#{first_line_break} #{I18n.t('mass_upload.errors.wrong_article', message: message, index: (index + 2))}")
    end
  end

  def save_articles!
    @articles.each do |article|
      article.calculate_fees_and_donations
      article.save!
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
    # Alle social_questionnaire attribute siehe (questionnaire_attrs) und dann hash per z.B. keep_if von den Sachen trennen

    # bugbug Work in progress
    # bugbug If there is a none verbose way to turn SocialProducerQuestionnaire.questionnaire_attrs into a nice Hash, go for it!
    social_producer_questionnaire_attributes = SocialProducerQuestionnaire.new.attributes
    social_producer_questionnaire_attributes.except!("id", "article_id")
    social_producer_questionnaire_attribute_keys = social_producer_questionnaire_attributes.keys
    fair_trust_questionnaire_attributes = FairTrustQuestionnaire.new.attributes
    fair_trust_questionnaire_attributes.except!("id", "article_id")
    fair_trust_questionnaire_attribute_keys = fair_trust_questionnaire_attributes.keys
    if row["fair_kind"] == "fair_trust"
      fair_trust_questionnaire_attributes_values = row.extract!(*fair_trust_questionnaire_attribute_keys)
      fair_trust_questionnaire_attributes_values.select { |key, value| key.to_s.match(/checkboxes/) }.each { |k, v| fair_trust_questionnaire_attributes_values[k] = v.delete(' ').split(',') }
      row["fair_trust_questionnaire_attributes"] = fair_trust_questionnaire_attributes_values
      row.except!(*social_producer_questionnaire_attribute_keys)
    elsif row["fair_kind"] == "social_producer"
      social_producer_questionnaire_attributes_values = row.extract!(*social_producer_questionnaire_attribute_keys)
      social_producer_questionnaire_attributes_values.select { |key, value| key.to_s.match(/checkboxes/) }.each { |k, v| social_producer_questionnaire_attributes_values[k] = v.delete(' ').split(',') }
      row["social_producer_questionnaire_attributes"] = social_producer_questionnaire_attributes_values
      row.except!(*fair_trust_questionnaire_attribute_keys)
    else
      row.except!(*social_producer_questionnaire_attribute_keys)
      row.except!(*fair_trust_questionnaire_attribute_keys)
    end
    row

    # bugbug Still needed?
    # row = row.to_a
    # fair_trust_questionnaire_attributes_array = row[28..47]
    # social_producer_questionnaire_attributes_array = row[48..54]
    # fair_trust_questionnaire_attributes = {}
    # social_producer_questionnaire_attributes = {}
    # row = row - fair_trust_questionnaire_attributes_array - social_producer_questionnaire_attributes_array
    # if row[26][1] == "fair_trust"
    #   # bugbug Eventuell auc mit Fair..questionnaire.new arbeiten und dann an den Artikel hängen
    #   key = "fair_trust_questionnaire_attributes"
    #   row = inject_questionnaire(fair_trust_questionnaire_attributes_array, fair_trust_questionnaire_attributes, row, key)
    # elsif row[26][1] == "social_producer"
    #   key = "social_producer_questionnaire_attributes"
    #   row = inject_questionnaire(social_producer_questionnaire_attributes_array, social_producer_questionnaire_attributes, row, key)
    # else
    #   row = Hash[row]
    # end
    # row
  end

  # bugbug Still needed?
  # def inject_questionnaire (attributes_array, attributes_hash, row, key)
  #   attributes_array.each do |pair|
  #     if pair[0].include?("checkboxes") && pair[1..-1].first && pair[1..-1].first.split(',').length == 1
  #       attributes_hash[pair.first] = pair[1].split
  #     elsif pair[1..-1].first && pair[1..-1].first.split(',').length > 1
  #       attributes_hash[pair.first] = pair[1..-1].join.delete(' ').split(',')
  #     else
  #       attributes_hash[pair.first] = pair[1..-1].first || [""]
  #     end
  #   end
  #   row = Hash[row]
  #   row[key] = attributes_hash
  #   row
  # end

  def add_commendation(article)
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