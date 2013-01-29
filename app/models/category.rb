class Category < ActiveRecord::Base
  has_many :auctions_categories
  has_many :auctions, :through => :auctions_categories
  
  validates :name, :uniqueness => true
  
  acts_as_nested_set
end
