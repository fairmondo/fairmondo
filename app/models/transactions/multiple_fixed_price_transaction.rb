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
  attr_accessible :quantity_available

  # Allow quantity_available field for this transaction type
  def quantity_available
    read_attribute :quantity_available
  end
  # Allow quantity_bought - /!\ ensure it's not saved here but only forwarded to a FixedPriceTransaction
  def quantity_bought
    read_attribute :quantity_bought
  end

  state_machine do
    before_transition on: :buy, do: :handle_multiple_transaction
  end

  private

    # The main transition handler (see class description)
    # @param transition [StateMachine::Transition]
    # @return [Boolean] Whether or not the transition to "sold" should proceed
    def handle_multiple_transaction transition
      if quantity_bought <= quantity_available
        fpt = FixedPriceTransaction.new()
        fpt.save!
        fpt.buy
        return (quantity_bought == quantity_available)
      else
        errors.add :quantity_bought, 'Nope'
        return false
      end
    end
end
