class LibraryElement < ActiveRecord::Base

  belongs_to :auction
  belongs_to :library
  
  attr_accessible :auction_id, :library_id
  
  validates :auction_id, :uniqueness => {:scope => :library_id}


end
