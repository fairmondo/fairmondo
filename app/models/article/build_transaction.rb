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
module Article::BuildTransaction
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_build_transaction # Can be set to true if a specific transaction is going to be provided. Used mainly for tests.

    before_create :build_specific_transaction, unless: :template?
    before_update :update_specific_transaction, unless: :template? # Do templates even receive update calls?
  end

  private
    # Create a transaction for every new article
    # @api private
    # @return [Transaction]
    def build_specific_transaction
      unless self.skip_build_transaction || self.transaction # Is it possible to provide two :unless params for after_create? -KK
        if self.quantity == 1
          fpt = SingleFixedPriceTransaction.create
        else
          fpt = MultipleFixedPriceTransaction.new
          fpt.quantity_available = self.quantity
          fpt.save
        end
        fpt.seller = self.seller
        self.transaction = fpt
      end
    end

    # When quantity was changed, the transaction needs to change
    def update_specific_transaction
      if self.transaction
        if self.quantity == 1 and self.transaction.is_a? MultipleFixedPriceTransaction
          self.transaction.transform_to_single
        elsif self.quantity > 1 and self.transaction.is_a? SingleFixedPriceTransaction
            self.transaction.transform_to_multiple self.quantity
        elsif self.quantity > 1 and self.transaction.is_a? MultipleFixedPriceTransaction
            self.transaction.update_attribute :quantity_available, self.quantity
        end
      end
    end

end
