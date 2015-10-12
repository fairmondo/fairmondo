#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module BusinessTransaction::Discountable
  extend ActiveSupport::Concern

  included do
    belongs_to :discount, foreign_key: 'discount_id'
    # fields for discounts
    delegate :discount_id, to: :article, prefix: true
    delegate :max_discounted_value_cents, :num_of_discountable_articles, :title, to: :discount, prefix: true
  end

  # Methods
  #
  # Here we have some methods that deal with discounting transactions
  # does this transaction qualify for a discount?
  #
  def discountable?
    discount = Discount.find(self.article_discount_id)
    discount && num_discounted_articles < discount.num_of_discountable_articles && value_discounted_articles < discount.max_discounted_value_cents
  end

  # finds all transactions that where discounted by specific discount
  def discounted
    BusinessTransaction.where(discount: discount).joins(:line_item_group).where('line_item_groups.seller_id' => seller.id)
  end

  # returns the number of articles, that have been discounted for specific discount
  def num_discounted_articles
    discounted.sum(:quantity_bought)
  end

  # returns the value of discounts granted for specific discount
  def value_discounted_articles
    discounted.sum('discount_value_cents * quantity_bought').to_i
  end

  def calculated_discount
    self.quantity_bought * (self.article_calculated_fee_cents / 100.0 * self.discount.percent)
  end

  def remaining_discount
    self.discount.max_discounted_value_cents - self.value_discounted_articles
  end
end
