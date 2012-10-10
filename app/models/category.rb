class Category < ActiveRecord::Base
  has_many :auctions
  def parent
    Category.find self.parent_id
  rescue 
    nil
  end
end
