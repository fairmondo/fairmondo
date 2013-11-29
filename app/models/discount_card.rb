class DiscountCard < ActiveRecord::Base
  belongs_to :discount
  belongs_to :user

  validates :discount_id, presence: true
  validates :user_id, presence: true
  validates :value_cents, presence: true
  validates :num_of_articles, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.create_or_update_discount_card transaction
    if seller_has_discount_card_for? transaction
    end
  end

  def self.seller_has_discount_card_for? transaction
    DiscountCard.find( discount_id: transaction.article.discount_id && user_id: transaction.seller_id)
  end
end
