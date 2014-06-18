class Address < ActiveRecord::Base
  belongs_to :user

 #validates :address_line_1, format: /\A.+\d+.*\z/, on: :update, unless: Proc.new {|c| c.address_line_1.blank?} # format: ensure digit for house number
 #validates :address_line_2, length: { maximum: 150 }
 #validates :zip, zip: true, on: :update, unless: Proc.new {|c| c.zip.blank?}, length: { maximum: 5 }
 #validates :city, length: { maximum: 150 }
 #validates :country, length: { maximum: 150  }
end
