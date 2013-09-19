#
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
module Article::Attributes
  extend ActiveSupport::Concern

  included do

    #common fields
    def self.common_attrs
      [:title, :content, :condition, :condition_extra  , :quantity , :transaction_attributes]
    end
    #! attr_accessible *common_attributes
    #! attr_accessible *common_attributes, :as => :admin

    auto_sanitize :content, method: 'tiny_mce'
    auto_sanitize :title


    #title

    validates_presence_of :title , :content
    validates_length_of :title, :minimum => 6, :maximum => 65


    #conditions

    validates_presence_of :condition
    validates_presence_of :condition_extra , if: :old?
    enumerize :condition, in: [:new, :old], predicates:  true
    enumerize :condition_extra, in: [:as_good_as_new, :as_good_as_warranted ,:used_very_good , :used_good, :used_satisfying , :broken] # refs #225


    #money_rails and price

    def self.money_attrs
      [:price_cents , :currency, :price, :vat]
    end
    #! attr_accessible *money_attributes
    #! attr_accessible *money_attributes, :as => :admin

    validates_presence_of :price_cents
    validates_numericality_of :price, greater_than_or_equal_to: 0

    monetize :price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10000 }


    # vat (Value Added Tax)

    validates :vat , presence: true , inclusion: { in: [0,7,19] },  if: :has_legal_entity_seller?


    # basic price
    def self.basic_price_attrs
      [:basic_price, :basic_price_cents, :basic_price_amount]
    end
    #! attr_accessible *basic_price_attributes
    #! attr_accessible *basic_price_attributes, :as => :admin

    monetize :basic_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10000 }, :allow_nil => true

    enumerize :basic_price_amount, in: [:kilogram, :gram, :liter, :milliliter, :cubicmeter, :meter, :squaremeter, :portion ]



    # =========== Transport =============
    TRANSPORT_TYPES = [:pickup, :type1, :type2]

    #transport
    def self.transport_attrs
      [:transport_pickup,
      :transport_type1, :transport_type1_price_cents,
      :transport_type1_price, :transport_type1_provider,
      :transport_type2, :transport_type2_price_cents,
      :transport_type2_price, :transport_type2_provider,
      :transport_details]
    end
    #! attr_accessible *transport_attributes
    #! attr_accessible *transport_attributes, :as => :admin

    auto_sanitize :transport_type1_provider, :transport_type2_provider, :transport_details

    validates :transport_type1_price, :transport_type1_provider, :presence => true ,:if => :transport_type1
    validates :transport_type2_price, :transport_type2_provider, :presence => true ,:if => :transport_type2
    validates :transport_details, :length => { :maximum => 2500 }

    monetize :transport_type2_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 500 }, :allow_nil => true
    monetize :transport_type1_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 500 }, :allow_nil => true


    # ================ Payment ====================
    PAYMENT_TYPES = [:bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice]

    #payment
    def self.payment_attrs
      [:payment_details,
      :payment_bank_transfer,
      :payment_cash,
      :payment_paypal,
      :payment_cash_on_delivery, :payment_cash_on_delivery_price , :payment_cash_on_delivery_price_cents,
      :payment_invoice]
    end
    #! attr_accessible *payment_attributes
    #! attr_accessible *payment_attributes, :as => :admin

    auto_sanitize :payment_details

    validates :payment_cash_on_delivery_price, :presence => true ,:if => :payment_cash_on_delivery

    before_validation :set_sellers_nested_validations

    monetize :payment_cash_on_delivery_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 500 }, :allow_nil => true

    validates :payment_details, :length => { :maximum => 2500 }

    validate :bank_account_exists, :if => :payment_bank_transfer
    validate :paypal_account_exists, :if => :payment_paypal

    validates_presence_of :quantity
    validates_numericality_of :quantity, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10000
    validate :payment_method_checked
  end

  def set_sellers_nested_validations
    seller.bank_account_validation = true if payment_bank_transfer
    seller.paypal_validation = true if payment_paypal
  end

  def has_legal_entity_seller?
    self.seller.is_a?(LegalEntity)
  end

  # Gives the price of the article minus taxes
  # @api public
  # @param quantity [Integer] Amount of articles calculated
  # @return [Money]
  def price_without_vat quantity = 1
    ( self.price * ( 100 - self.vat ) / 100 ) * quantity
  end

  # Gives the amount of money for an article that goes towards taxes
  # @api public
  # @param quantity [Integer] Amount of articles calculated
  # @return [Money]
  def vat_price quantity = 1
    ( self.price * self.vat / 100 ) * quantity
  end

  # Function to calculate total price for an article.
  # Note: Params should have already been validated.
  #
  # @api public
  # @param selected_transport [String] Transport type
  # @param selected_payment [String] Payment type
  # @param selected_payment [Integer] Amount of articles bought
  # @return [Money] Total billed price
  def total_price selected_transport, selected_payment, quantity
    quantity ||= 1
    total = self.price + self.transport_price(selected_transport)
    total += self.payment_cash_on_delivery_price if selected_payment == "cash_on_delivery"
    total * quantity
  end

  # Gives the shipping cost for a specified transport type
  #
  # @api public
  # @param transport_type [String] The transport type to look up
  # @param quantity [Integer]
  # @return [Money] The shipping price
  def transport_price transport_type, quantity = 1
    case transport_type
    when "type1"
      transport_type1_price * quantity
    when "type2"
      transport_type2_price * quantity
    else
      Money.new 0
    end
  end

  # Gives the shipping provider for a specified transport type
  #
  # @api public
  # @param transport_type [String] The transport type to look up
  # @return [Money] The shipping provider
  def transport_provider transport_type
    case transport_type
    when "type1"
      transport_type1_provider
    when "type2"
      transport_type2_provider
    else
      nil
    end
  end

  # Returns an array with all selected transport types.
  # Default transport will be the first element.
  #
  # @api public
  # @return [Array] An array with selected transport types.
  def selectable_transports
    selectable "transport"
  end

  # Returns an array with all selected payment types.
  # Default payment will be the first element.
  #
  # @api public
  # @return [Array] An array with selected payment types.
  def selectable_payments
    selectable "payment"
  end

  private

    def payment_method_checked
      unless self.payment_bank_transfer || self.payment_paypal || self.payment_cash || self.payment_cash_on_delivery || self.payment_invoice
        errors.add(:payment_details, I18n.t("article.form.errors.invalid_payment_option"))
      end
    end

    # DRY method for selectable_transports and selectable_payments
    #
    # @api private
    # @return [Array] An array with selected attribute types
    def selectable attribute
      # Get all selected attributes
      output = []
      eval("#{attribute.upcase}_TYPES").each do |e|
        output << e if self.send "#{attribute}_#{e}"
      end
      output
    end



    def bank_account_exists
      if !self.seller.bank_account_exists?
        errors.add(:payment_bank_transfer, I18n.t("article.form.errors.bank_details_missing"))
      end
    end

    def paypal_account_exists
      if !self.seller.paypal_account_exists?
        errors.add(:payment_paypal, I18n.t("article.form.errors.paypal_details_missing"))
      end
    end
end
