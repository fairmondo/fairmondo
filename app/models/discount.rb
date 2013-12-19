class Discount < ActiveRecord::Base
  extend Sanitization

  has_many :transactions
  has_many :articles

  validates :title, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :percent, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_discounted_value_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :num_of_discountable_articles, presence: true, numericality: { greater_than_or_equal_to: 0 }

  auto_sanitize :title, :description

  scope :current, lambda { where( "start_time < ? AND end_time > ?", Time.now, Time.now ) }

  def self.discount_chain transaction
    if transaction.discountable?
      transaction.discount_id = transaction.article_discount_id

      if transaction.calculated_discount > transaction.remaining_discount
        transaction.discount_value_cents = transaction.remaining_discount
      else
        transaction.discount_value_cents = transaction.calculated_discount
      end
    end
    transaction.save
  end
end
