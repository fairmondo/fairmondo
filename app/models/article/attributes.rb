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

    attr_accessible :title, :content, :condition  ,:condition_extra  , :quantity , :transaction_attributes
    auto_sanitize :content, method: 'tiny_mce'
    auto_sanitize :title

    #title

    validates_presence_of :title , :content, :unless => :template? # refs #128
    validates_length_of :title, :minimum => 6, :maximum => 65

    #conditions

    validates_presence_of :condition
    validates_presence_of :condition_extra , :if => :old?
    enumerize :condition, :in => [:new, :old], :predicates =>  true
    enumerize :condition_extra, :in => [:as_good_as_new, :as_good_as_warranted ,:used_very_good , :used_good, :used_satisfying , :broken] # refs #225

    #money_rails and price

    attr_accessible :price_cents , :currency, :price, :vat

    validates_presence_of :price_cents

    validates_numericality_of :price,
    :greater_than_or_equal_to => 0

    monetize :price_cents

    # vat

    validates_presence_of :vat , :if => :has_legal_entity_seller?

    # basic price
    attr_accessible :basic_price,:basic_price_cents, :basic_price_amount

    monetize :basic_price_cents, :allow_nil => true

    enumerize :basic_price_amount, :in => [:kilogram, :gram, :liter, :milliliter, :cubicmeter, :meter, :squaremeter, :portion ]



    # =========== Transport =============

    #transport
    attr_accessible :default_transport, :transport_pickup,
                    :transport_insured, :transport_insured_price_cents,
                    :transport_insured_price, :transport_insured_provider,
                    :transport_uninsured, :transport_uninsured_price_cents,
                    :transport_uninsured_price, :transport_uninsured_provider,
                    :transport_details

    auto_sanitize :transport_insured_provider, :transport_uninsured_provider, :transport_details

    enumerize :default_transport, :in => [:pickup, :insured, :uninsured]

    validates_presence_of :default_transport
    validates :transport_insured_price, :transport_insured_provider, :presence => true ,:if => :transport_insured
    validates :transport_uninsured_price, :transport_uninsured_provider, :presence => true ,:if => :transport_uninsured


    monetize :transport_uninsured_price_cents, :allow_nil => true
    monetize :transport_insured_price_cents, :allow_nil => true

    validate :default_transport_selected


    # ================ Payment ====================

    #payment
    attr_accessible :default_payment ,:payment_details ,
                    :payment_bank_transfer,
                    :payment_cash,
                    :payment_paypal,
                    :payment_cash_on_delivery, :payment_cash_on_delivery_price , :payment_cash_on_delivery_price_cents,
                    :payment_invoice,
                    :seller_attributes
    auto_sanitize :payment_details

    enumerize :default_payment, :in => [:bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice]

    validates_presence_of :default_payment

    validates :payment_cash_on_delivery_price, :presence => true ,:if => :payment_cash_on_delivery

    accepts_nested_attributes_for :seller , :update_only => true

    before_validation :set_sellers_nested_validations

    monetize :payment_cash_on_delivery_price_cents, :allow_nil => true


    validates_presence_of :quantity
    validates_numericality_of :quantity, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10000

    validate :default_payment_selected
  end

  def set_sellers_nested_validations
    seller.bank_account_validation = true if payment_bank_transfer
    seller.paypal_validation = true if payment_paypal
  end

  def has_legal_entity_seller?
    self.seller.is_a?(LegalEntity)
  end

  def default_transport_selected
    if self.default_transport
      unless self.send("transport_#{self.default_transport}")
        errors.add(:default_transport, I18n.t("errors.messages.invalid_default_transport"))
      end
    end
  end

  def default_payment_selected
    if self.default_payment
      unless self.send("payment_#{self.default_payment}")
        errors.add(:default_payment, I18n.t("errors.messages.invalid_default_payment"))
      end
    end
  end




end
