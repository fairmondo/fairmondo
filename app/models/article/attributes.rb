#
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
module Article::Attributes
  extend ActiveSupport::Concern

  included do

    #common fields
    common_attributes = [:title, :content, :condition  ,:condition_extra  , :quantity , :transaction_attributes]
    attr_accessible *common_attributes
    attr_accessible *common_attributes, :as => :admin

    auto_sanitize :content, method: 'tiny_mce'
    auto_sanitize :title

    #title

    validates_presence_of :title , :content
    validates_length_of :title, :minimum => 6, :maximum => 65

    #conditions

    validates_presence_of :condition
    validates_presence_of :condition_extra , :if => :old?
    enumerize :condition, :in => [:new, :old], :predicates =>  true
    enumerize :condition_extra, :in => [:as_good_as_new, :as_good_as_warranted ,:used_very_good , :used_good, :used_satisfying , :broken] # refs #225

    #money_rails and price

    money_attributes = [:price_cents , :currency, :price, :vat]
    attr_accessible *money_attributes
    attr_accessible *money_attributes, :as => :admin

    validates_presence_of :price_cents

    monetize :price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10000 }


    # vat

    validates :vat , presence: true , inclusion: { in: [0,7,19] },  if: :has_legal_entity_seller?

    # basic price
    basic_price_attributes = [:basic_price, :basic_price_cents, :basic_price_amount]
    attr_accessible *basic_price_attributes
    attr_accessible *basic_price_attributes, :as => :admin

    monetize :basic_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10000 }, :allow_nil => true

    enumerize :basic_price_amount, :in => [:kilogram, :gram, :liter, :milliliter, :cubicmeter, :meter, :squaremeter, :portion ]

    # custom seller identifier

    attr_accessible :custom_seller_identifier
    validates_length_of :custom_seller_identifier, :maximum => 65


    # =========== Transport =============

    #transport
    transport_attributes = [:default_transport, :transport_pickup,
                    :transport_type1, :transport_type1_price_cents,
                    :transport_type1_price, :transport_type1_provider,
                    :transport_type2, :transport_type2_price_cents,
                    :transport_type2_price, :transport_type2_provider,
                    :transport_details]
    attr_accessible *transport_attributes
    attr_accessible *transport_attributes, :as => :admin

    auto_sanitize :transport_type1_provider, :transport_type2_provider, :transport_details

    enumerize :default_transport, :in => [:pickup, :type1, :type2]

    validates_presence_of :default_transport
    validates :transport_type1_price, :transport_type1_provider, :presence => true ,:if => :transport_type1
    validates :transport_type2_price, :transport_type2_provider, :presence => true ,:if => :transport_type2
    validates :transport_details, :length => { :maximum => 2500 }

    monetize :transport_type2_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 500 }, :allow_nil => true
    monetize :transport_type1_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 500 }, :allow_nil => true

    validate :default_transport_selected


    # ================ Payment ====================

    #payment
    payment_attributes = [:payment_details ,
                    :payment_bank_transfer,
                    :payment_cash,
                    :payment_paypal,
                    :payment_cash_on_delivery, :payment_cash_on_delivery_price , :payment_cash_on_delivery_price_cents,
                    :payment_invoice]
    attr_accessible *payment_attributes
    attr_accessible *payment_attributes, :as => :admin

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

  private

    def default_transport_selected
      if self.default_transport
        unless self.send("transport_#{self.default_transport}")
          errors.add(:default_transport, I18n.t("errors.messages.invalid_default_transport"))
        end
      end
    end

    def payment_method_checked
      unless self.payment_bank_transfer || self.payment_paypal || self.payment_cash || self.payment_cash_on_delivery || self.payment_invoice
        errors.add(:payment_details, I18n.t("article.form.errors.invalid_payment_option"))
      end
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
