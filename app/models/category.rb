class Category < ActiveRecord::Base
  has_many :auctions
  belongs_to :parent, :class_name => "Category"
end
