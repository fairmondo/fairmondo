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
      transition :processing => :finished, :if => :can_finish?
      transition :finished => :finished
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

  has_many :mass_upload_articles
  has_many :articles, through: :mass_upload_articles

  has_many :created_articles, through: :mass_upload_articles, source: :article, conditions: {"mass_upload_articles.action" => "create"}
  has_many :updated_articles, through: :mass_upload_articles, source: :article, conditions: {"mass_upload_articles.action" => "update"}
  has_many :deleted_articles, through: :mass_upload_articles, source: :article, conditions: {"mass_upload_articles.action" => "delete"}
  has_many :deactivated_articles, through: :mass_upload_articles, source: :article, conditions: {"mass_upload_articles.action" => "deactivate"}
  has_many :activated_articles, through: :mass_upload_articles, source: :article, conditions: {"mass_upload_articles.action" => "activate"}
  has_many :articles_for_mass_activation, through: :mass_upload_articles, source: :article,
            conditions: "mass_upload_articles.action IN ('create', 'update', 'activate')"

  has_many :erroneous_articles
  has_attached_file :file
  belongs_to :user

  validates_attachment :file, presence: true,
    size: { in: 0..20.megabytes },
    content_type: { :content_type => ['text/csv','application/excel','application/vnd.msexcel','text/anytext','application/vnd.ms-excel', 'application/octet-stream', 'application/force-download', 'text/comma-separated-values'] }


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

  def processed_articles_count
    self.erroneous_articles.count + self.mass_upload_articles.count
  end

  def process
    ProcessMassUploadWorker.perform_async(self.id)
  end


  private

    # Check if finish conditions are met
    def can_finish?
      self.row_count and
      self.processed_articles_count >= self.row_count
    end
end