#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class MassUpload < ActiveRecord::Base
  include Assets::Normalizer
  include Checks, Questionnaire, FeesAndDonations, Associations, State

  scope :processing, -> { where(state: :processing) }

  def self.article_attributes
    %w(
      € id title categories condition condition_extra
      content quantity price_cents basic_price_cents
      basic_price_amount vat external_title_image_url image_2_url
      transport_pickup transport_type1
      transport_type1_provider transport_type1_price_cents
      transport_type1_number transport_type2 transport_type2_provider
      transport_type2_price_cents transport_type2_number transport_time
      transport_details unified_transport
      payment_bank_transfer payment_cash payment_paypal
      payment_cash_on_delivery payment_voucher
      payment_cash_on_delivery_price_cents payment_invoice
      payment_details fair_kind fair_seal support
      support_checkboxes support_other support_explanation
      labor_conditions labor_conditions_checkboxes
      labor_conditions_other labor_conditions_explanation
      environment_protection environment_protection_checkboxes
      environment_protection_other
      environment_protection_explanation controlling
      controlling_checkboxes controlling_other
      controlling_explanation awareness_raising
      awareness_raising_checkboxes awareness_raising_other
      awareness_raising_explanation nonprofit_association
      nonprofit_association_checkboxes
      social_businesses_muhammad_yunus
      social_businesses_muhammad_yunus_checkboxes
      social_entrepreneur social_entrepreneur_checkboxes
      social_entrepreneur_explanation ecologic_seal
      upcycling_reason small_and_precious_eu_small_enterprise
      small_and_precious_reason small_and_precious_handmade
      gtin custom_seller_identifier action
    )
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
    self.row_count &&
    self.processed_articles_count >= self.row_count
  end
end
