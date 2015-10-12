#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# A transaction handles the purchase process of an article.

class BusinessTransaction < ActiveRecord::Base
  extend Enumerize
  extend Sanitization
  extend RailsAdminStatistics

  include BusinessTransaction::Refundable, BusinessTransaction::Discountable, BusinessTransaction::Scopes

  belongs_to :article, inverse_of: :business_transactions

  belongs_to :line_item_group

  has_one :seller, through: :line_item_group
  has_one :buyer, through: :line_item_group

  enumerize :selected_transport, in: Article::TRANSPORT_TYPES
  enumerize :selected_payment, in: Article::PAYMENT_TYPES

  delegate :title, :selectable_transports, :selectable_payments,
           :payment_cash_on_delivery_price,
           :basic_price, :basic_price_amount, :basic_price_amount_text, :price,
           :quantity, :quantity_left,
           :transport_type1_provider, :transport_type2_provider, :calculated_fair,
           :calculated_fair_cents, :calculated_fee, :calculated_fee_cents,
           :friendly_percent, :friendly_percent_organisation, :vat,
           :custom_seller_identifier, :cash_on_delivery_price,
           :active?, :transport_time,
           to: :article, prefix: true
  delegate :email, :nickname, to: :buyer, prefix: true
  delegate :nickname, :phone, :mobile, to: :seller, prefix: true
  delegate :title, :first_name, :last_name, :address_line_1, :address_line_2, :company_name,
           :zip, :city, :country, to: :transport_address, prefix: true
  delegate :title, :first_name, :last_name, :address_line_1, :address_line_2, :company_name,
           :zip, :city, :country, to: :payment_address, prefix: true
  delegate :email, :fullname, :nickname, :phone, :mobile, :address,
           :bank_account_owner, :bank_account_number, :bank_code, :bank_name,
           :about, :terms, :cancellation, :paypal_account, :ngo, :iban, :bic,
           :vacationing?, :cancellation_form,
           to: :article_seller, prefix: true
  delegate :url, to: :article_seller_cancellation_form, prefix: true
  delegate :payment_address, :transport_address, :purchase_id, :cart_id, to: :line_item_group
  # delegate :buyer, :seller, to: :line_item_group

  validates :selected_transport, inclusion: { in: proc { |record| record.article.selectable_transports } }, presence: true, unless: :is_in_unified_transport?
  validates :selected_payment, inclusion: { in: proc { |record| record.article.selectable_payments } }, common_sense: true, presence: true

  validates :line_item_group, presence: true
  validates :article, presence: true

  # validations for transport_bike_courier
  #
  with_options if: :bike_courier_selected? do |bt|
    bt.validates :tos_bike_courier_accepted, acceptance: { allow_nil: false, accept: true }
    bt.validates :bike_courier_time, presence: true
    bt.validates :bike_courier_message, length: { maximum: 500 }

    # custom validations
    bt.validate :transport_address_in_area?
    # bt.validate :right_time_frame_for_bike_courier?
  end

  state_machine initial: :sold do
    state :sold, :paid, :ready, :sent, :completed do
    end

    event :pay do
      transition sold: :paid
    end

    event :prepare do
      transition [:sold, :paid] => :ready
    end

    event :ship do
      transition [:sold, :paid, :ready] => :sent
    end

    event :receive do
      transition sent: :completed
    end
  end

  def selected_transport_provider
    case selected_transport
    when 'pickup'
      'pickup'
    when 'bike_courier'
      'bike_courier'
    when 'type1'
      article.transport_type1_provider
    when 'type2'
      article.transport_type2_provider
    end
  end

  def is_in_unified_transport?
    article.unified_transport? && line_item_group.unified_transport?
  end

  def refunded?
    refunded_fee && refunded_fair
  end

  def billed_for_refund_fair=(value)
    self.refunded_fair = value
  end

  def billed_for_refund_fee=(value)
    self.refunded_fee = value
  end

  def billed_for_refund_fair
    refunded_fair
  end

  def billed_for_refund_fee
    refunded_fee
  end

  def bike_courier_selected?
    self.selected_transport == 'bike_courier'
  end

  def voucher_selected?
    self.selected_payment == 'voucher'
  end

  def total_fair_cents
    quantity_bought * article_calculated_fair_cents
  end

  # only LegalEntities will be billed, sales for PrivateUsers are free
  def billable?
    self.seller.is_a?(LegalEntity)
  end

  private

  # Custom conditions for validations
  #
  def transport_address_in_area?
    unless COURIER['zip'].split(' ').include?(self.transport_address_zip)
      errors.add(
        :selected_transport,
        I18n.t('transaction.errors.transport_address_not_in_area')
      )
    end
  end

  def right_time_frame_for_bike_courier?
    unless self.seller.pickup_time.include? self.bike_courier_time
      errors.add(
        :bike_courier_time, I18n.t('transaction.errors.wrong_time_frame')
      )
    end
  end
end
