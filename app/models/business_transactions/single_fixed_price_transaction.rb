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
class SingleFixedPriceTransaction < BusinessTransaction
  extend STI

  # Validations for buyer address
  # validates :forename, presence: true, on: :update
  # validates :surname, presence: true, on: :update
  # validates :street, presence: true, on: :update
  # validates :city, presence: true, on: :update
  # validates :zip, presence: true, on: :update
  # validates :country, presence: true, on: :update

  state_machine do
    after_transition on: :buy, do: :set_article_sold
  end

  # Allow quantity_bought
  def quantity_bought
    read_attribute :quantity_bought
  end
  # Only one can be bought. It's the whole point.
  def quantity_bought= number
    super 1
  end
  validates :quantity_bought, presence: true, numericality: true, on: :update, if: :updating_state

  # for having a parallel structure to MultipleFPT
  def quantity_available
    self.sold? ? 0 : 1
  end

  # This might be called on article update when quantity has changed to more than 1
  def transform_to_multiple quantity
    self.type = 'MultipleFixedPriceTransaction'
    self.class.send :define_method, :quantity_available do
      read_attribute :quantity_available
    end
    self.quantity_available = quantity
    self.save!
  end

  private
    def set_article_sold
      self.article.sold_out
    end
end
