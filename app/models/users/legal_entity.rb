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

  def self.user_attrs
    super + [:terms, :cancellation,
      :about, :percentage_of_positive_ratings, :percentage_of_neutral_ratings, :percentage_of_negative_ratings]
  end
  #! attr_accessible :terms, :cancellation, :about
  #! attr_accessible :percentage_of_positive_ratings, :percentage_of_neutral_ratings, :percentage_of_negative_ratings

  with_options if: :wants_to_sell? do |seller|
    # validates legal entity
    seller.validates :terms , :presence => true , :length => { :maximum => 20000 } , :on => :update
    seller.validates :cancellation , :presence => true , :length => { :maximum => 10000 } , :on => :update
    seller.validates :about , :presence => true , :length => { :maximum => 10000 } , :on => :update
  end

  state_machine :seller_state, :initial => :standard_seller do
    event :rate_up do
      transition standard_seller: :good1_seller, good1_seller: :good2_seller, good2_seller: :good3_seller, good3_seller: :good4_seller
    end

    event :update_seller_state do
      transition all => :bad_seller, if: lambda {|user| (user.percentage_of_negative_ratings > 25) }
      transition bad_seller: :standard_seller, if: lambda {|user| (user.percentage_of_positive_ratings > 75) }
      transition standard_seller: :good1_seller, if: lambda {|user| (user.percentage_of_positive_ratings > 90) }
      transition good1_seller: :good2_seller, if: lambda {|user| (user.percentage_of_positive_ratings > 90 && user.has_enough_positive_ratings_in([100])) }
      transition good2_seller: :good3_seller, if: lambda {|user| (user.percentage_of_positive_ratings > 90 && user.has_enough_positive_ratings_in([100, 500])) }
      transition good3_seller: :good4_seller, if: lambda {|user| (user.percentage_of_positive_ratings > 90 && user.has_enough_positive_ratings_in([100, 500, 1000])) }
    end
  end

  def commercial_seller_constants
    commercial_seller_constants = {
      :standard_salesvolume => $commercial_seller_constants['standard_salesvolume'],
      :verified_bonus => $commercial_seller_constants['verified_bonus'],
      :good_factor => $commercial_seller_constants['good_factor'],
      :bad_salesvolume => $commercial_seller_constants['bad_salesvolume']
    }
  end

  def max_value_of_goods_cents
    salesvolume = commercial_seller_constants[:standard_salesvolume]

    salesvolume += commercial_seller_constants[:verified_bonus]  if self.verified
    salesvolume *= commercial_seller_constants[:good_factor]     if good1_seller?
    salesvolume *= commercial_seller_constants[:good_factor]**2  if good2_seller?
    salesvolume *= commercial_seller_constants[:good_factor]**3  if good3_seller?
    salesvolume *= commercial_seller_constants[:good_factor]**4  if good4_seller?
    salesvolume = commercial_seller_constants[:bad_salesvolume]  if bad_seller?

    salesvolume
  end

  def has_enough_positive_ratings_in last_ratings
    value = true
    last_ratings.each do |rating|
      value = value && calculate_percentage_of_biased_ratings( "positive", rating ) > 90
    end
    value
  end

  # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  def self.model_name
    User.model_name
  end
end
