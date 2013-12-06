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
class MassUpload < ActiveRecord::Base

  state_machine :initial => :pending do
    event :start do
      transition :pending => :processing
    end

    event :error do
      transition :processing => :failed
      transition :failed => :failed # maybe another worker calls it
    end

    event :finish do
      transition :processing => :finished, :if => lambda {|mass_upload| mass_upload.processed_articles_count >= mass_upload.row_count }
    end

    after_transition :to => :finished do |mass_upload,transition|
      mass_upload.user.notify I18n.t('mass_uploads.labels.finished'),  Rails.application.routes.url_helpers.mass_upload_path(mass_upload)
    end

    after_transition :processing => :failed do |mass_upload, transition|
      mass_upload.failure_reason = transition.args.first
      mass_upload.save
      mass_upload.user.notify I18n.t('mass_uploads.labels.failed'), Rails.application.routes.url_helpers.user_path(mass_upload.user, anchor: "my_mass_uploads"), :error
    end
  end

  include Checks, Questionnaire, FeesAndDonations

  has_many :articles

  has_many :created_articles, :class_name => 'Article', :conditions => {:activation_action => "create"}
  has_many :updated_articles, :class_name => 'Article', :conditions => {:activation_action => "update"}
  has_many :deleted_articles, :class_name => 'Article', :conditions => {:state => "closed"}
  has_many :deactivated_articles, :class_name => 'Article', :conditions => {:state => "locked"}
  has_many :activated_articles, :class_name => 'Article', :conditions => {:activation_action => "activate"}

  has_many :erroneous_articles
  has_attached_file :file
  belongs_to :user

  validates_attachment :file, presence: true,
    :size => { :in => 0..20.megabytes }
  validate :csv_format

  def self.mass_upload_attrs
    [:file]
  end

  def self.article_attributes
   ["€", "id", "title", "categories", "condition", "condition_extra",
    "content", "quantity", "price_cents", "basic_price_cents",
    "basic_price_amount", "vat", "external_title_image_url", "image_2_url",
    "transport_pickup", "transport_type1",
    "transport_type1_provider", "transport_type1_price_cents",
    "transport_type1_number", "transport_type2", "transport_type2_provider",
    "transport_type2_price_cents", "transport_type2_number", "transport_details",
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

  def self.transaction_attributes
    ["sales_price_cents", "price_without_vat_cents", "vat_cents",
      "selected_transport", "transport_provider", "shipping_and_handling_cents",
      "selected_payment", "message", "quantity_bought", "forename", "surname",
      "address_suffix", "street", "city", "zip", "country", "buyer_email",
      "fee_cents", "donation_cents", "total_fee_cents", "net_total_fee_cents",
      "vat_total_fee_cents", "sold_at"]
  end

  def articles_for_mass_activation
     self.created_articles + self.updated_articles + self.activated_articles
  end

  def empty?
    self.articles.empty? && self.erroneous_articles.empty?
  end

  def processed_articles_count
    self.erroneous_articles.size + self.articles.size
  end

  def process_without_delay
    self.start
    begin
      row_count = 0
      row_buffer = {}

      CSV.foreach(self.file.path, encoding: get_csv_encoding(self.file.path), col_sep: ';', quote_char: '"', headers: true) do |row|
        row_count += 1
        row.delete '€' # delete encoding column
        row_buffer[row_count] = row
        if row_buffer.size >= 50
          process_rows row_buffer # handles the buffer asynchronously
          row_buffer = {}
        end
      end
      unless row_buffer.empty? # handle the rest
        process_rows row_buffer
      end
      self.update_attribute(:row_count, row_count)
    rescue ArgumentError
      self.error(I18n.t('mass_uploads.errors.wrong_encoding'))
    rescue CSV::MalformedCSVError
      self.error(I18n.t('mass_uploads.errors.illegal_quoting'))
    rescue => e
      log_exception e
      self.error(I18n.t('mass_uploads.errors.unknown_error'))
    end

  end

  def process
    Delayed::Job.enqueue ProcessMassUploadJob.new(self.id)
  end

  def process_rows rows
    if self.processing?
      begin
        rows.each do |index,row|
          process_row row,index
        end
      rescue => e
        log_exception e
        return self.error(I18n.t('mass_uploads.errors.unknown_error'))
      end
    end
    self.finish
  end
  handle_asynchronously :process_rows

  def log_exception e
       message = "#{Time.now.strftime('%FT%T%z')}: #{e} \nbacktrace: #{e.backtrace}"
       Delayed::Worker.logger.add Logger::INFO, message
       puts message
  end

  def process_row row, index
    row_hash = sanitize_fields row.to_hash
    categories = Category.find_imported_categories(row_hash['categories'])
    row_hash.delete("categories")
    row_hash = Questionnaire.include_fair_questionnaires(row_hash)
    row_hash = Questionnaire.add_commendation(row_hash)
    article = Article.create_or_find_according_to_action row_hash, user

    if article # so we can ignore rows when reimporting
      article.user_id = self.user_id
      revise_prices(article)
      article.categories = categories if categories
      if article.was_invalid_before? # invalid? call would clear our previous base errors
                                     # fix this by generating the base errors with proper validations
                                     # may be hard for dynamic update model
        add_article_error_messages(article, index, row)
      else
        article.calculate_fees_and_donations
        article.mass_upload = self
        article.process!
      end
    end
  end

  def add_article_error_messages(article, index, row)
    validation_errors = ""
    expanded_row = ";" + row.to_csv(:col_sep => ";") # Because the "€" column has been deleted before
                                                     #we have to prepend the csv with a ";" because
                                                     # otherwise the content wouldn't match withe the article_attributes anymore
    article.errors.full_messages.each do |message|
      validation_errors += message + "\n"
    end
      ErroneousArticle.create(
        validation_errors: validation_errors,
        row_index: index,
        mass_upload: self,
        article_csv: expanded_row
      )
      # TODO Check if the original row number can be given as well
  end

  def revise_prices(article)
    article.basic_price ||= 0
    article.transport_type1_price_cents ||= 0
    article.transport_type2_price_cents ||= 0
    article.payment_cash_on_delivery_price_cents ||= 0
  end

  def update_solr_index_for article_ids
    articles = Article.find article_ids
    Sunspot.index articles
    Sunspot.commit
  end
  handle_asynchronously :update_solr_index_for

  private
    # Throw away additional fields that are not needed
    def sanitize_fields row_hash
      row_hash.keys.each do |key|
        row_hash.delete key unless MassUpload.article_attributes.include? key
      end
      row_hash
    end
end