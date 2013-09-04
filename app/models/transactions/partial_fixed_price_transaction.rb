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
class PartialFixedPriceTransaction < SingleFixedPriceTransaction
  extend STI

  belongs_to :parent, class_name: 'MultipleFixedPriceTransaction', inverse_of: :children
  belongs_to :article, inverse_of: :partial_transactions
  has_one :buyer, through: :parent

  #validates :quantity_bought, numericality: true, on: :update
  validates :parent_id, presence: true

  # Allow quantity_bought field for this transaction type
  def quantity_bought
    read_attribute :quantity_bought
  end

  private
    def set_article_sold
      # Will be set in MFPT
      true
    end
end
