#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LegalEntity < User
  extend STI
  extend Tokenize

  validates :terms, length: { maximum: 40000, tokenizer: tokenizer_without_html }
  validates :about, length: { maximum: 10000, tokenizer: tokenizer_without_html }
  validates :cancellation, length: { maximum: 10000, tokenizer: tokenizer_without_html }
  validates_attachment :cancellation_form, size: { in: 1..2.megabytes }, file_name: { matches: [/pdf\Z/] }

  with_options if: :wants_to_sell? do |seller|
    # validates legal entity
    seller.validates :direct_debit, acceptance: { accept: true }, on: :update
    seller.validates :bank_account_owner, :iban, :bic,  presence: true
    seller.validates :terms, presence: true, on: :update
    seller.validates :about, presence: true, on: :update
    seller.validates :cancellation, presence: true, on: :update
  end

  state_machine :seller_state, initial: :standard_seller do
    event :rate_up do
      transition standard_seller: :good1_seller, good1_seller: :good2_seller, good2_seller: :good3_seller, good3_seller: :good4_seller
    end

    event :update_seller_state do
      transition all => :bad_seller, if: lambda { |user| (user.percentage_of_negative_ratings > 25) }
      transition bad_seller: :standard_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 75) }
      transition standard_seller: :good1_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 90) }
      transition good1_seller: :good2_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 90 && user.has_enough_positive_ratings_in([100])) }
      transition good2_seller: :good3_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 90 && user.has_enough_positive_ratings_in([100, 500])) }
      transition good3_seller: :good4_seller, if: lambda { |user| (user.percentage_of_positive_ratings > 90 && user.has_enough_positive_ratings_in([100, 500, 1000])) }
    end
  end

  def commercial_seller_constants
    {
      standard_salesvolume: COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'],
      verified_bonus: COMMERCIAL_SELLER_CONSTANTS['verified_bonus'],
      good_factor: COMMERCIAL_SELLER_CONSTANTS['good_factor'],
      bad_salesvolume: COMMERCIAL_SELLER_CONSTANTS['bad_salesvolume']
    }
  end

  def max_value_of_goods_cents
    return commercial_seller_constants[:bad_salesvolume] if bad_seller?

    salesvolume = commercial_seller_constants[:standard_salesvolume]
    salesvolume += commercial_seller_constants[:verified_bonus] if verified?
    salesvolume *= good_factor
    salesvolume
  end

  def good_factor
    (1..4).each do |value|
      if self.send("good#{ value }_seller?")
        return commercial_seller_constants[:good_factor]**value
      end
    end
    1
  end

  def has_enough_positive_ratings_in last_ratings
    value = true
    last_ratings.each do |rating|
      value = value && calculate_percentage_of_biased_ratings('positive', rating) > 90
    end
    value
  end

  def can_refund? business_transaction
    Time.now <= business_transaction.sold_at + 45.days
  end

  # see http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
  def self.model_name
    User.model_name
  end
end
