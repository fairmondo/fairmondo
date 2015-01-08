# A transaction handles the purchase process of an article.
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
  delegate :nickname, to: :seller, prefix: true
  delegate :title, :first_name, :last_name, :address_line_1, :address_line_2, :company_name,
           :zip, :city, :country, to: :transport_address, prefix: true
  delegate :title, :first_name, :last_name, :address_line_1, :address_line_2, :company_name,
           :zip, :city, :country, to: :payment_address, prefix: true
  delegate :email, :fullname, :nickname, :phone, :mobile, :address,
           :bank_account_owner, :bank_account_number, :bank_code, :bank_name,
           :about, :terms, :cancellation, :paypal_account,:ngo, :iban, :bic,
           :vacationing?, :cancellation_form,
           to: :article_seller, prefix: true
  delegate :url, to: :article_seller_cancellation_form, prefix: true
  delegate :payment_address, :transport_address, :purchase_id, :cart_id, to: :line_item_group
  #delegate :buyer, :seller, to: :line_item_group



  validates :selected_transport, inclusion: { in: proc { |record| record.article.selectable_transports } }, presence: true , unless: :is_in_unified_transport?
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
    #bt.validate :right_time_frame_for_bike_courier?
  end

  state_machine initial: :sold do

    state :sold, :paid, :ready, :sent, :completed do
    end

    event :pay do
      transition :sold => :paid
    end

    event :prepare do
      transition [:sold, :paid] => :ready
    end

    event :ship do
      transition [:sold, :paid, :ready] => :sent
    end

    event :receive do
      transition :sent => :completed
    end
  end


  # TODO Check if there is a better way -> only used in export model
  def selected_transport_provider
    if self.selected_transport == "pickup"
      "pickup"
    elsif self.selected_transport == "bike_courier"
      "bike_courier"
    elsif self.selected_transport == "type1"
      self.article.transport_type1_provider
    elsif self.selected_transport == "type2"
      self.article.transport_type2_provider
    end
  end


  def is_in_unified_transport?
    article.unified_transport? && line_item_group.unified_transport?
  end

  def refunded?
    refunded_fee && refunded_fair
  end

  def bike_courier_selected?
    self.selected_transport == 'bike_courier'
  end

  private

    # Custom conditions for validations
    #
    def transport_address_in_area?
      unless $courier['zip'].split(' ').include?(self.transport_address_zip)
        errors.add(:selected_transport, I18n.t('transaction.errors.transport_address_not_in_area'))
      end
    end

    def right_time_frame_for_bike_courier?
      unless self.seller.pickup_time.include? self.bike_courier_time
        errors.add(:bike_courier_time, I18n.t('transaction.errors.wrong_time_frame'))
      end
    end

end
