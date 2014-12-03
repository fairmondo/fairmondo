# encoding: UTF-8
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
class MassUpload < ActiveRecord::Base

  include Assets::Normalizer

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

    event :mass_activate do
      transition :finished => :activated
      transition :activated => :activated
    end

    after_transition :to => :finished do |mass_upload, transition|
      ArticleMailer.delay.mass_upload_finished_message(mass_upload.id)
    end

    after_transition :processing => :failed do |mass_upload, transition|
      mass_upload.failure_reason = transition.args.first
      mass_upload.save
      ArticleMailer.delay.mass_upload_failed_message(mass_upload.id)
    end

    after_transition :to => :activated do |mass_upload, transition|
      Indexer.delay.index_mass_upload mass_upload.id
      mass_upload.articles_for_mass_activation.update_all(state: 'active')
      ArticleMailer.delay.mass_upload_activation_message(mass_upload.id)
    end
  end

  scope :processing, -> { where(state: :processing) }

  include Checks, Questionnaire, FeesAndDonations

  has_many :mass_upload_articles
  has_many :articles, through: :mass_upload_articles

  has_many :created_articles, -> { where('mass_upload_articles.action' => 'create') }, through: :mass_upload_articles, source: :article
  has_many :updated_articles, -> { where('mass_upload_articles.action' => 'update') }, through: :mass_upload_articles, source: :article
  has_many :deleted_articles, -> { where('mass_upload_articles.action' => 'delete') }, through: :mass_upload_articles, source: :article
  has_many :deactivated_articles, -> { where('mass_upload_articles.action' => 'deactivate') }, through: :mass_upload_articles, source: :article
  has_many :activated_articles, -> { where('mass_upload_articles.action' => 'activate') }, through: :mass_upload_articles, source: :article
  has_many :articles_for_mass_activation, -> { where("mass_upload_articles.action IN ('create', 'update', 'activate')") } , through: :mass_upload_articles, source: :article
  has_many :skipped_articles, -> { where('mass_upload_articles.action' => 'nothing') }, through: :mass_upload_articles, source: :article

  has_many :valid_mass_upload_articles, -> { where(validation_errors: nil).where.not(article_id: nil) }, class_name: 'MassUploadArticle'
  has_many :erroneous_articles, -> { where.not(validation_errors: nil) }, class_name: 'MassUploadArticle'

  has_attached_file :file
  belongs_to :user

  delegate :nickname, to: :user, prefix: true

  validates_attachment :file, presence: true,
    size: { in: 0..100.megabytes },
    content_type: { :content_type => ['text/csv','application/excel','application/vnd.msexcel','text/anytext','application/vnd.ms-excel', 'application/octet-stream', 'application/force-download', 'text/comma-separated-values'] }

  def self.article_attributes
   ["€", "id", "title", "categories", "condition", "condition_extra",
    "content", "quantity", "price_cents", "basic_price_cents",
    "basic_price_amount", "vat", "external_title_image_url", "image_2_url",
    "transport_pickup", "transport_type1",
    "transport_type1_provider", "transport_type1_price_cents",
    "transport_type1_number", "transport_type2", "transport_type2_provider",
    "transport_type2_price_cents", "transport_type2_number", "transport_time",
    "transport_details", "unified_transport",
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

  def processed_articles_count
    self.valid_mass_upload_articles.count + self.erroneous_articles.count
  end

  def process
    if self.user.heavy_uploader?
      Sidekiq::Client.push('queue' => 'heavy_mass_upload',
                           'class' => ProcessMassUploadWorker,
                           'args' => [self.id])
    else
      ProcessMassUploadWorker.perform_async(self.id)
    end
  end


  private

    # Check if finish conditions are met
    def can_finish?
      self.row_count and
      self.processed_articles_count >= self.row_count
    end
end
