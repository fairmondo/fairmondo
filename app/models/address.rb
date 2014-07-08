class Address < ActiveRecord::Base
  belongs_to :user
  has_one :connected_user, class_name: 'User', foreign_key: :standard_address_id, inverse_of: :standard_address

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_1, presence: true, format: /\A.+\d+.*\z/ # format: ensure digit for house number
  validates :address_line_2, length: { maximum: 150 }
  validates :zip, presence: true, zip: true, length: { maximum: 5 }
  validates :city, presence: true, length: { maximum: 150 }
  validates :country, presence: true, length: { maximum: 150 }

  extend Sanitization

  auto_sanitize :title, :first_name, :last_name, :address_line_1, :address_line_2, :zip, :city, :country
end
