# A transaction handles the purchase process of an article.
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
class BusinessTransaction < ActiveRecord::Base
  extend Enumerize
  extend Sanitization

  include BusinessTransaction::Refundable, BusinessTransaction::Discountable, BusinessTransaction::Scopes

  belongs_to :article, inverse_of: :business_transactions

  belongs_to :line_item_group
  belongs_to :payment, inverse_of: :business_transactions

  enumerize :selected_transport, in: Article::TRANSPORT_TYPES
  enumerize :selected_payment, in: Article::PAYMENT_TYPES

  delegate :title, :seller, :selectable_transports, :selectable_payments,
           :transport_provider, :transport_price, :payment_cash_on_delivery_price,
           :basic_price, :basic_price_amount, :basic_price_amount_text, :price,
           :price_without_vat, :total_price, :quantity, :quantity_left,
           :transport_type1_provider, :transport_type2_provider, :calculated_fair,
           :calculated_fair_cents, :calculated_fee, :calculated_fee_cents,
           :friendly_percent, :friendly_percent_organisation, :vat_price, :vat,
           :custom_seller_identifier, :number_of_shipments, :cash_on_delivery_price,
           :active?, :transport_time,
           to: :article, prefix: true
  delegate :email, :nickname, to: :buyer, prefix: true
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
  delegate :payment_address, :transport_address, to: :line_item_group
  delegate :buyer, :seller, to: :line_item_group



  validates :selected_transport, inclusion: { in: proc { |record| record.article.selectable_transports } }, presence: true
  validates :selected_payment, inclusion: { in: proc { |record| record.article.selectable_payments } }, common_sense: true, presence: true

  validates :line_item_group, presence: true
  validates :payment, presence: true, if: proc { |record| record.selected_payment == 'paypal' }
  validates :article, presence: true

  state_machine initial: :sold do

    state :sold, :paid, :sent, :completed do
    end

    event :pay do
      transition :sold => :paid
    end

    event :ship do
      transition :paid => :sent
    end

    event :receive do
      transition :sent => :completed
    end

  end


  # Shortcut for article_total_price working with saved data
  def total_price
    self.article_total_price(
      self.selected_transport,
      self.selected_payment,
      self.quantity_bought
    )
  end


  # TODO Check if there is a better way -> only used in export model
  def selected_transport_provider
    if self.selected_transport == "pickup"
      "pickup"
    elsif self.selected_transport == "type1"
      self.article.transport_type1_provider
    elsif self.selected_transport == "type2"
      self.article.transport_type2_provider
    end
  end

end
