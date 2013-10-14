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

  def upgrade_seller_state
    if self.seller_state == "standard_seller"
       self.rate_up_to_good1_seller
    elsif (self.seller_state == "good1_seller") || (self.seller_state == "good2_seller") ||  (self.seller_state == "good3_seller")
      percentage_of_positive_ratings_in_last_100 = calculate_percentage_of_biased_ratings 'positive', 100
      if percentage_of_positive_ratings_in_last_100 > 90
        if self.seller_state == "good1_seller"
          self.rate_up_to_good2_seller
        else
          percentage_of_positive_ratings_in_last_500 = calculate_percentage_of_biased_ratings 'positive', 500
          if percentage_of_positive_ratings_in_last_500 > 90
            if self.seller_state == "good2_seller"
              self.rate_up_to_good3_seller
            else
              percentage_of_positive_ratings_in_last_1000 = calculate_percentage_of_biased_ratings 'positive', 1000
              if percentage_of_positive_ratings_in_last_1000 > 90
                self.rate_up_to_good4_seller
              end
            end
          end
        end
      end
    end
  end


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

  def commercial_seller_constants
    commercial_seller_constants = {
      :standard_salesvolume => $commercial_seller_constants['standard_salesvolume'],
      :verified_bonus => $commercial_seller_constants['verified_bonus'],
      :good_factor => $commercial_seller_constants['good_factor'],
      :bad_salesvolume => $commercial_seller_constants['bad_salesvolume']
    }
  end

  def sales_volume
    bad_seller? ? commercial_seller_constants[:bad_salesvolume] :
    (( commercial_seller_constants[:standard_salesvolume] +
    ( self.verified ? commercial_seller_constants[:verified_bonus] : 0 ) ) *
    ( good1_seller? ? commercial_seller_constants[:good_factor] : 1 ) *
    ( good2_seller? ? commercial_seller_constants[:good_factor]**2 : 1 ) *
    ( good3_seller? ? commercial_seller_constants[:good_factor]**3 : 1 ) *
    ( good4_seller? ? commercial_seller_constants[:good_factor]**4 : 1 ))
  end

  # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  def self.model_name
    User.model_name
  end


end