class Address < ActiveRecord::Base
  belongs_to :user
  has_many :business_transactions, foreign_key: 'billing_address_id'
  has_many :business_transactions, foreign_key: 'shipping_address_id'

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_1, presence: true, format: /\A.+\d+.*\z/, on: [:update, :create] # format: ensure digit for house number
  validates :address_line_2, length: { maximum: 150 }
  validates :zip, presence: true, zip: true, length: { maximum: 5 }
  validates :city, presence: true, length: { maximum: 150 }
  validates :country, presence: true, length: { maximum: 150  }
end
