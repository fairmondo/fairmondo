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
class AuctionTransaction < Transaction

  attr_protected :max_bid
  attr_readonly :expire

  has_one :max_bid ,:class_name => 'Bid'
  has_many :bids

  validates_presence_of :expire
  #validate :validate_expire

  # other

  ### Comment back in when this is used and testable
  # def validate_expire
  #   return false unless self.expire
  #   if self.expire < 1.hours.from_now
  #     self.errors.add(:expire, "Expire time must be at least one hour in the future.")
  #     return false
  #   end
  #   if self.expire > 1.years.from_now
  #     self.errors.add(:expire, "Expire time must less than one year from now.")
  #     return false
  #   end
  #   return true
  # end

end
