#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Discount < ActiveRecord::Base
  extend Sanitization

  has_many :business_transactions
  has_many :articles

  validates :title, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :percent, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_discounted_value_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :num_of_discountable_articles, presence: true, numericality: { greater_than_or_equal_to: 0 }

  auto_sanitize :title, :description

  scope :current, lambda { where('start_time < ? AND end_time > ?', Time.now, Time.now) }

  def self.discount_chain business_transaction
    if business_transaction.discountable?
      business_transaction.discount_id = business_transaction.article_discount_id

      if business_transaction.calculated_discount > business_transaction.remaining_discount
        business_transaction.discount_value_cents = business_transaction.remaining_discount
      else
        business_transaction.discount_value_cents = business_transaction.calculated_discount
      end
    end
    business_transaction.save
  end
end
