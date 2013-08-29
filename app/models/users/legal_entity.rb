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

  def upgrade_seller_state
    if self.seller_state == 'good1_seller'
      calculate_percentage_of_positive_ratings 100
      if self.percentage_of_positive_ratings > 90
        self.rate_up_to_good2_seller
      end

    elsif self.seller_state == 'good2_seller'
      calculate_percentage_of_positive_ratings 500
      if self.percentage_of_positive_ratings > 90
        self.rate_up_to_good3_seller
      end

    elsif self.seller_state == 'good3_seller'
      calculate_percentage_of_positive_ratings 1000
      if self.percentage_of_positive_ratings > 90
        self.rate_up_to_good4_seller
      end

    else
      self.rate_up_to_good1_seller
      self.rate_up_to_standard_seller
    end
  end


  attr_accessible :terms, :cancellation, :about
  attr_accessible :percentage_of_positive_ratings, :percentage_of_negative_ratings

   # validates legal entity
  validates :terms , :presence => true , :length => { :maximum => 20000 } , :on => :update
  validates :cancellation , :presence => true , :length => { :maximum => 10000 } , :on => :update
  validates :about , :presence => true , :length => { :maximum => 10000 } , :on => :update


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
      :standard_salesvolume => 35,
      :verified_bonus => 50,
      :good_factor => 2,
      :bad_factor => 2
    }
  end

  def sales_volume
    bad_seller? ? ( commercial_seller_constants[:standard_salesvolume] / commercial_seller_constants[:bad_factor] ) :
    ( commercial_seller_constants[:standard_salesvolume] +
    ( self.verified ? commercial_seller_constants[:verified_bonus] : 0 ) ) *
    ( good1_seller? ? commercial_seller_constants[:good_factor] : 1 ) *
    ( good2_seller? ? commercial_seller_constants[:good_factor]**2 : 1 ) *
    ( good3_seller? ? commercial_seller_constants[:good_factor]**3 : 1 ) *
    ( good4_seller? ? commercial_seller_constants[:good_factor]**4 : 1 )
  end

  # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  def self.model_name
    User.model_name
  end

  private

  def calculate_percentage_of_positive_ratings number_of_ratings
    newest_ratings = self.ratings.limit(number_of_ratings)
    number_of_newest_ratings = newest_ratings.count.to_f
    number_of_positive_ratings = newest_ratings.select { |rates| rates.rating == 'positive' }.count
    percentage_of_positive_ratings = number_of_positive_ratings / number_of_newest_ratings * 100

    self.update_attributes(:percentage_of_positive_ratings => percentage_of_positive_ratings)
    self.save
  end


end
