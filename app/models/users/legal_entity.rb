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
  validates :terms , :presence => true , :length => { :maximum => 20000 } , :on => :update
  validates :cancellation , :presence => true , :length => { :maximum => 10000 } , :on => :update
  validates :about , :presence => true , :length => { :maximum => 10000 } , :on => :update


  COMMERCIAL_BAD_FACTOR = 2
  COMMERCIAL_GOOD_FACTOR = 2

  COMMERCIAL_STANDARD_SALESVOLUME = 35
  COMMERCIAL_VERIFIED_BONUS = 50


  state_machine :seller_state, :initial => :standard_seller do

    event :rate_up_to_good1_seller do
      transition :standard_seller => :good1_seller
    end
    event :rate_up_to_good2_seller do
      transition :good1_seller => :good2_seller
    end
    event :rate_up_to_good3_seller do
      transition :good2_seller => :good3_seller
    end
    event :rate_up_to_good4_seller do
      transition :good3_seller => :good4_seller
    end
  end

  def sales_volume
    bad_seller ? ( COMMERCIAL_STANDARD_SALESVOLUME / COMMERCIAL_BAD_FACTOR ) :
    ( COMMERCIAL_STANDARD_SALESVOLUME +
    ( self.verified ? COMMERCIAL_VERIFIED_BONUS : 0 ) ) *
    ( good1_seller? ? COMMERCIAL_GOOD_FACTOR : 1 ) *
    ( good2_seller? ? COMMERCIAL_GOOD_FACTOR**2 : 1 ) *
    ( good3_seller? ? COMMERCIAL_GOOD_FACTOR**3 : 1 ) *
    ( good4_seller? ? COMMERCIAL_GOOD_FACTOR**4 : 1 )
  end

  # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  def self.model_name
    User.model_name
  end


end
