class Address < ActiveRecord::Base
  belongs_to :user
  has_one :connected_user, class_name: 'User', foreign_key: :standard_address_id, inverse_of: :standard_address
  has_many :business_transactions, foreign_key: 'billing_address_id'
  has_many :business_transactions, foreign_key: 'shipping_address_id'

  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update
  validates :address_line_1, presence: true, format: /\A.+\d+.*\z/, on: :update # format: ensure digit for house number
  validates :address_line_2, length: { maximum: 150 }, on: :update
  validates :zip, presence: true, zip: true, length: { maximum: 5 }, on: :update
  validates :city, presence: true, length: { maximum: 150 }, on: :update
  validates :country, presence: true, length: { maximum: 150  }, on: :update

  extend Sanitization

  auto_sanitize :title, :first_name, :last_name, :address_line_1, :address_line_2, :zip, :city, :country
end
