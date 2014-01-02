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
class PrivateUser < User
  extend STI

  state_machine :seller_state, :initial => :standard_seller do
    event :rate_up do
      transition :standard_seller => :good_seller
    end

    event :update_seller_state do
      transition all => :bad_seller, if: lambda { |user| (user.percentage_of_negative_ratings > 25) }
      transition bad_seller: :standard_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 75) }
      transition standard_seller: :good_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 90) }
    end

  end

  def private_seller_constants
    private_seller_constants = {
      :standard_salesvolume => $private_seller_constants['standard_salesvolume'],
      :verified_bonus => $private_seller_constants['verified_bonus'],
      :trusted_bonus => $private_seller_constants['trusted_bonus'],
      :good_factor => $private_seller_constants['good_factor'],
      :bad_salesvolume => $private_seller_constants['bad_salesvolume']
    }
  end

  def max_value_of_goods_cents
    salesvolume = private_seller_constants[:standard_salesvolume]

    salesvolume += private_seller_constants[:trusted_bonus]   if self.trustcommunity
    salesvolume += private_seller_constants[:verified_bonus]  if self.verified
    salesvolume *= private_seller_constants[:good_factor]     if good_seller?
    salesvolume = private_seller_constants[:bad_salesvolume]  if bad_seller?

    salesvolume
  end

  def can_refund? transaction
    Time.now >= transaction.sold_at + 14.days && Time.now <= transaction.sold_at + 28.days
  end

  # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  def self.model_name
    User.model_name
  end

end
