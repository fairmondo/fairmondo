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
class TransactionPolicy < Struct.new(:user, :transaction)

  def edit?
    !own? && purchasable?
  end

  def update?
    edit?
  end

  def show?
    user.is?(transaction.article_seller) || user.is?(transaction.buyer)
  end

  def already_sold?
    true
  end

  def print_order_buyer?
    user.is?(transaction.buyer)
  end

  def print_order_seller?
    user.is?(transaction.article_seller)
  end

  private
    def own?
      user ? user.articles.include?(transaction.article) : false
    end

    def purchasable?
      transaction.article_active? && !transaction.article_seller_vacationing?
    end
end
