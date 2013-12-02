class DiscountCard < ActiveRecord::Base
  belongs_to :discount
  belongs_to :user

  validates :discount_id, presence: true
  validates :user_id, presence: true
  validates :value_cents, presence: true
  validates :num_of_articles, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :current, find( discount_id: transaction.article_discount_id, user_id: transaction.seller_id)


  def self.create_or_update_discount_card transaction
    if discount_card_for? transaction
      value_cents = DiscountCard.current.value_cents + transaction.article_price_cents
      num_of_articles = DiscountCard.current.num_of_articles + transaction.quantity

      DiscountCard.current.update_attributes( value_cents: value_cents, num_of_articles: num_of_articles )
    else
      DiscountCard.create(  
                          user_id: transaction.seller_id,
                          discount_id: transaction.article_discount_id,
                          value_cents: transaction.article_price_cents,
                          num_of_articles: transaction.quantity 
                         )
    end
  end

  def self.discount_card_for? transaction
    DiscountCard.current
  end
end
