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
class BusinessTransactionPolicy < Struct.new(:user, :business_transaction)

  def edit?
    !own? && purchasable?
  end

  def update?
    edit?
  end

  def show?
    user.is?(business_transaction.article_seller) || user.is?(business_transaction.buyer)
  end

  def already_sold?
    true
  end

  def print_order_buyer?
    user.is?(business_transaction.buyer)
  end

  def print_order_seller?
    user.is?(business_transaction.article_seller)
  end

  def show_vacationing?
    !own? && business_transaction.article_active?
  end

  private
    def own?
      user ? user.articles.include?(business_transaction.article) : false
    end

    def purchasable?
      business_transaction.article_active? && !business_transaction.article_seller_vacationing?
    end
end
