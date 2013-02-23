class Library < ActiveRecord::Base
  
  validates :name, :uniqueness => {:scope => :user_id}
  validates :name, :presence => true
  validates :user_id, :presence => true
  
  belongs_to :user
  has_many :library_elements
  
  attr_accessible :name, :public, :user_id, :user
  
  scope :public, where(:public=>true)
  
end
