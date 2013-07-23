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
class LegalEntity < User
  extend STI

  attr_accessible :terms, :cancellation, :about
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
  # validates legal entity
  validates_presence_of :terms , :on => :update
  validates_presence_of :cancellation , :on => :update
  validates_presence_of :about , :on => :update


  COMMERCIAL_BAD_FACTOR = 2
  COMMERCIAL_GOOD_FACTOR = 2

  COMMERCIAL_STANDARD_SALESVOLUME = 1500
  COMMERCIAL_VERIFIED_BONUS = 48500
  VERIFIED = false


  state_machine :seller_state, :initial => :standard do
    # if more than 90% positive ratings in the last 50 ratings:
    event :rate_up_to_good do
      transition :standard => :good1, :good1 => :good2, :good2 => :good3, :good3 => :good4
    end
  end

  def sales_volume
    bad? ? ( COMMERCIAL_STANDARD_SALESVOLUME / COMMERCIAL_BAD_FACTOR ) :
    ( COMMERCIAL_STANDARD_SALESVOLUME + ( VERIFIED ? COMMERCIAL_VERIFIED_BONUS : 0 ) ) *
    ( good1? ? COMMERCIAL_GOOD_FACTOR : 1 ) * ( good2? ? COMMERCIAL_GOOD_FACTOR**2 : 1 ) * ( good3? ? COMMERCIAL_GOOD_FACTOR**3 : 1 ) * ( good4? ? COMMERCIAL_GOOD_FACTOR**4 : 1 )
  end

end
