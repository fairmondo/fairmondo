class Address < ActiveRecord::Base
  belongs_to :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_1, presence: true, format: /\A.+\d+.*\z/, on: :update, unless: Proc.new {|c| c.address_line_1.blank?} # format: ensure digit for house number
  validates :address_line_2, length: { maximum: 150 }
  validates :zip, presence: true, zip: true, length: { maximum: 5 }
  validates :city, presence: true, length: { maximum: 150 }
  validates :country, presence: true, length: { maximum: 150  }
end
