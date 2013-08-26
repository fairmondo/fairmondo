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
class MultipleFixedPriceTransaction < Transaction
  extend STI

  has_many :children, class_name: 'PartialFixedPriceTransaction', inverse_of: :parent

  # Allow quantity_available field for this transaction type
  def quantity_available
    read_attribute :quantity_available
  end
  # Allow quantity_bought - /!\ ensure it's not saved here but only forwarded to a PartialFixedPriceTransaction
  def quantity_bought
    read_attribute :quantity_bought
  end

  state_machine do
    before_transition on: :buy, do: :buy_multiple_transaction
    after_transition on: :buy, if: :sold_out_after_buy? do |t, transition|
      t.article.sold_out
    end
  end

  # The field 'quantity_available' isn't accessible directly and should only be decreased after sales with this function
  # @api public
  # @param number [Integer]
  # @return [Integer, Booldean] Total quantity_available if successful, else Boolean false
  def reduce_quantity_available_by number
    self.quantity_available = self.quantity_available - number
    self.save!
  end

  # The main transition handler (see class description)
  # @return [undefined] not important
  def buy_multiple_transaction
    self.quantity_bought ||= 1
    if self.quantity_bought <= self.quantity_available
      fpt = PartialFixedPriceTransaction.new parent: self, quantity_bought: self.quantity_bought
      fpt.save!
      reduce_quantity_available_by self.quantity_bought if fpt.buy
    else
      errors.add :quantity_bought, "You can't buy more than we have available"
    end
    true
  end

  # MFPT wait before being sold out
  def sold_out_after_buy?
    self.quantity_available == 0
  end
end

#ey du hau ma quantity_sold raus