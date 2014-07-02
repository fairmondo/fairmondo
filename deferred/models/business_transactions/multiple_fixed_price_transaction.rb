# MultipleFPT are generated for articles with a quantity of more than one.
# It will start with a quantity_available of the same amount as the
# article's quantity. When a MFPT is processed, it will create a new FPT
# with a certain quantity_bought and reduce it's own quantity_available by
# that amount. When quantity_available is zero, it will transition to a
# "sold" state.
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
class MultipleFixedPriceTransaction < BusinessTransaction
  extend STI

  has_many :children, class_name: 'PartialFixedPriceTransaction', foreign_key: 'parent_id', inverse_of: :parent

  validates :quantity_available, presence: true, numericality: true
  validates :quantity_bought, numericality: { greater_than: 0, less_than_or_equal_to: ->(record) { record.quantity_available } }, allow_nil: true

  # Allow quantity_available field for this transaction type
  def quantity_available
    read_attribute :quantity_available
  end
  # Allow quantity_bought - /!\ ensure it's not saved here but only forwarded to a PartialFixedPriceTransaction
  def quantity_bought
    read_attribute :quantity_bought
  end

  state_machine do
    before_transition on: :buy, do: :buy_multiple_business_transactions
    after_transition on: :buy, if: :sold_out_after_buy? do |t, transition|
      t.article.sold_out
    end
  end

  def deletable?
    super && children.empty?
  end


  # The field 'quantity_available' isn't accessible directly and should only be decreased after sales with this function
  # @api public
  # @param number [Integer]
  # @return [Integer, Booldean] Total quantity_available if successful, else Boolean false
  def reduce_quantity_available_by number
    self.quantity_available = self.quantity_available - number
  end

  # The main transition handler (see class description)
  # @return [Boolean] not important
  def buy_multiple_business_transactions
    self.quantity_bought ||= 1
    if self.quantity_bought <= self.quantity_available # should not be false
      self.forwarding_data_to_partial = true
      fpt = self.forward_data_to_partial
      reduce_quantity_available_by self.quantity_bought if fpt.buy
      clear_data
    end
    true
  end

  # buyer, quantity_bought, transport_selected, and payment_selected shouldn't be saved on a MFPT but only be forwarded to the PartialFPT
  def forward_data_to_partial
    partial = PartialFixedPriceTransaction.create({
      quantity_bought: self.quantity_bought,
      selected_transport: self.selected_transport,
      selected_payment: self.selected_payment,
      message: self.message,
      forename: self.forename,
      surname: self.surname,
      address_suffix: self.address_suffix,
      street: self.street,
      city: self.city,
      zip: self.zip,
      country: self.country
    })

    # protected attrs
    partial.parent = self
    partial.article = self.article
    partial.buyer = self.buyer
    partial.seller = self.seller

    partial.save!
    return partial
  end

  def clear_data
    self.buyer = nil
    self.quantity_bought = nil
    self.selected_transport = nil
    self.selected_payment = nil
    self.message = nil
    self.forename = nil
    self.surname = nil
    self.address_suffix = nil
    self.street = nil
    self.city = nil
    self.zip = nil
    self.country = nil
    self.tos_accepted = nil
  end

  # This might be called on article update when quantity has changed to 1
  def transform_to_single
    self.update_column :quantity_available, nil
    self.update_column :type, 'SingleFixedPriceTransaction'
  end

  private
    # MFPTs wait before being sold out
    def sold_out_after_buy?
      self.quantity_available == 0
    end
end
