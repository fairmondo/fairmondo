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

  #
  # We cannot validate on user directly else resend password bzw. reset passwort does not work
  # if the user object doesnt validate and the user cannot reset his password!
  #
  # validates user
  validates_presence_of :forename , :on => :update
  validates_presence_of :surname , :on => :update
  validates_presence_of :title , :on => :update
  validates_presence_of :country , :on => :update
  validates_presence_of :street , :on => :update
  validates_presence_of :city , :on => :update
  validates_presence_of :zip , :on => :update

  PRIVATE_BAD_FACTOR = 2
  PRIVATE_GOOD_FACTOR = 2

  PRIVATE_STANDARD_SALESVOLUME = 20
  PRIVATE_TRUSTED_BONUS = 20
  PRIVATE_VERIFIED_BONUS = 35


  state_machine :seller_state, :initial => :standard do

    event :rate_up_to_good do
      transition :standard => :good
    end
  end

  def sales_volume
    ( bad? ? ( PRIVATE_STANDARD_SALESVOLUME / PRIVATE_BAD_FACTOR ) :
    ( PRIVATE_STANDARD_SALESVOLUME + ( self.trustcommunity ? PRIVATE_TRUSTED_BONUS : 0 ) + ( self.verified ? PRIVATE_VERIFIED_BONUS : 0) ) * ( good? ? PRIVATE_GOOD_FACTOR : 1  ))
  end

end
