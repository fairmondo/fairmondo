class Discount < ActiveRecord::Base
  extend Sanitization

  def self.discount_attrs
    []
  end

  has_many :discount_cards

  validates :title, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :percent, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :max_discounted_value_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :num_of_discountable_articles, presence: true, numericality: { greater_than_or_equal_to: 0 }

  auto_sanitize :title, :description

  scope :current, where( "start_time < ? AND end_time > ?", Time.now, Time.now )
end
