# A transaction handles the purchase process of an artucle.
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
class Transaction < ActiveRecord::Base
  extend Enumerize
  extend Sanitization

  has_one :article
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'

  transaction_attributes = [:selected_transport, :selected_payment, :tos_accepted, :message, :quantity_bought]
  attr_accessible *transaction_attributes
  attr_accessible *(transaction_attributes + [:quantity_available]), as: :admin

  attr_protected :buyer_id, :state, :quantity_available

  auto_sanitize :message

  enumerize :selected_transport, in: Article::TRANSPORT_TYPES
  enumerize :selected_payment, in: Article::PAYMENT_TYPES

  delegate :title, :seller, :selectable_transports, :selectable_payments,
           :transport_provider, :transport_price, :payment_cash_on_delivery_price,
           :basic_price, :basic_price_amount, :price, :vat, :vat_price,
           :price_without_vat, :total_price, :quantity, :quantity_left,
           :transport_type1_provider, :transport_type2_provider, :calculated_fair,
           to: :article, prefix: true
  delegate :email, to: :buyer, prefix: true
  delegate :email, :fullname, :nickname, :phone, :mobile, :address,
           to: :article_seller, prefix: true

  validates :tos_accepted, acceptance: { accept: true, message: I18n.t('errors.messages.multiple_accepted') }, on: :update
  #validates :message, allow_blank: true, on: :update

  state_machine initial: :available do

    state :available do
    end

    state :sold do
    end

    state :paid do
    end

    state :sent do
    end

    state :completed do
    end

    event :buy do
      transition :available => :sold, if: :sold_out_after_buy?
      transition :available => same
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

  # Per default a transaction automatically is sold out after the first buy event, except for MultipleFPT
  def sold_out_after_buy?
    true
  end

  # Make virtual field validatable
  # @api public
  # @param value [String]
  # @return [Boolean]
  def tos_accepted= value
    @tos_accepted = (value == "1")
  end
  attr_reader :tos_accepted


  # Edit can be called with GET params. If they are valid, it renders a different
  # view to show the final sales price. This method is called to validates if the
  # params are valid.
  #
  # @api public
  # @param params [Hash] The GET parameters
  # @return [Boolean]
  def edit_params_valid? params
    unless params["transaction"] && params["transaction"]["selected_payment"] && params["transaction"]["selected_transport"]
      return false
    end

    supports?("transport", params["transaction"]["selected_transport"]) &&
    supports?("payment", params["transaction"]["selected_payment"]) &&
    quantity_param_valid?(params)
  end

  # Get transport options that were selected by seller
  #
  # @api public
  # @return [Array] Array in 2 levels with option name and it's localization
  def selected_transports
    selected "transport"
  end

  # Get payment options that were selected by seller
  #
  # @api public
  # @return [Array] Array in 2 levels with option name and it's localization
  def selected_payments
    selected "payment"
  end

  # Shortcut for article_total_price working with saved data
  def total_price
    self.article_total_price(
      self.selected_transport,
      self.selected_payment,
      self.quantity_bought
    )
  end

  protected
    # Disallow these fields in general. Will be overwritten for specific subclasses that need these fields.
    def quantity_available; raise NoMethodError; end
    def quantity_bought; raise NoMethodError; end

    # Quantity is valid in general. Will change for MFPT
    def quantity_param_valid? params
      true
    end

  private
    # Check if seller allowed [transport/payment] type of [type] for the associated article. Also sets error message
    #
    # @api private
    # @param attribute [String] ATM: payment or transport
    # @param type [String] The type to check
    # @return [Boolean]
    def supports? attribute, type
      if self.article.send "#{attribute}_#{type}?"
        true
      else
        errors["selected_#{attribute}".to_sym] = I18n.t "transaction.notices.#{attribute}_not_supported"
        false
      end
    end

    # Get attribute options that were selected on transaction's article
    #
    # @api private
    # @param attribute [String] "transport" or "payment" (enums that have a counter part in the article model)
    # @return [Array] Array in 2 levels with enum option name and it's localization
    def selected attribute
      selectables = send("article_selectable_#{attribute}s")
      Transaction.send("selected_#{attribute}").options.select { |e| selectables.include? e[1].to_sym }
    end
end
