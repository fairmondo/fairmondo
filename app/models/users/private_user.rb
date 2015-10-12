#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PrivateUser < User
  extend STI

  state_machine :seller_state, initial: :standard_seller do
    event :rate_up do
      transition standard_seller: :good_seller
    end

    event :update_seller_state do
      transition all => :bad_seller, if: lambda { |user| (user.percentage_of_negative_ratings > 25) }
      transition bad_seller: :standard_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 75) }
      transition standard_seller: :good_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 90) }
    end
  end

  def private_seller_constants
    {
      standard_salesvolume: PRIVATE_SELLER_CONSTANTS['standard_salesvolume'],
      verified_bonus: PRIVATE_SELLER_CONSTANTS['verified_bonus'],
      trusted_bonus: PRIVATE_SELLER_CONSTANTS['trusted_bonus'],
      good_factor: PRIVATE_SELLER_CONSTANTS['good_factor'],
      bad_salesvolume: PRIVATE_SELLER_CONSTANTS['bad_salesvolume']
    }
  end

  def max_value_of_goods_cents
    salesvolume = private_seller_constants[:standard_salesvolume]

    salesvolume += private_seller_constants[:verified_bonus]  if self.verified
    salesvolume *= private_seller_constants[:good_factor]     if good_seller?
    salesvolume = private_seller_constants[:bad_salesvolume]  if bad_seller?

    salesvolume
  end

  def can_refund? business_transaction
    Time.now >= business_transaction.sold_at + 14.days && Time.now <= business_transaction.sold_at + 28.days
  end

  # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  def self.model_name
    User.model_name
  end
end
