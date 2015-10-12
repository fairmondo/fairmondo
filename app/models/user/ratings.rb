#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module User::Ratings
  extend ActiveSupport::Concern

  # Update percentage of positive and negative ratings of seller
  # @api public
  # @return [undefined]
  def update_rating_counter
    number_of_ratings = self.ratings.count

    self.update_attributes(percentage_of_positive_ratings: calculate_percentage_of_biased_ratings('positive', 50),
                           percentage_of_neutral_ratings:  calculate_percentage_of_biased_ratings('neutral', 50),
                           percentage_of_negative_ratings: calculate_percentage_of_biased_ratings('negative', 50))

    if (self.is_a?(LegalEntity) && number_of_ratings > 50) || (self.is_a?(PrivateUser) && number_of_ratings > 20)
      if percentage_of_negative_ratings > 50
        self.banned = true
      end
      update_seller_state
    end
  end

  # Calculates percentage of positive and negative ratings of seller
  # @api public
  # @param bias [String] positive or negative
  # @param limit [Integer]
  # @return [Float]
  def calculate_percentage_of_biased_ratings(bias, limit)
    biased_ratings = { 'positive' => 0, 'negative' => 0, 'neutral' => 0 }
    self.ratings.select(:rating).limit(limit).each do |rating|
      biased_ratings[rating.value] += 1
    end
    number_of_considered_ratings = biased_ratings.values.sum
    number_of_biased_ratings = biased_ratings[bias] || 0
    number_of_biased_ratings.fdiv(number_of_considered_ratings) * 100
  end

  def buyer_constants
    {
      not_registered_purchasevolume: 4,
      standard_purchasevolume: 12,
      trusted_bonus: 12,
      good_factor: 2,
      bad_purchasevolume: 6
    }
  end

  def purchase_volume
    purchase_volume = buyer_constants[:standard_purchasevolume]

    purchase_volume *= buyer_constants[:good_factor]        if good_buyer?
    purchase_volume = buyer_constants[:bad_purchasevolume]  if bad_buyer?
    purchase_volume
  end
end
