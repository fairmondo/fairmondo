class Library < ActiveRecord::Base
  
  validates :name, :uniqueness => {:scope => :user_id}
  validates :name, :presence => true
  validates :user_id, :presence => true
  
  belongs_to :user, :dependent => :destroy
  has_many :library_elements
  
  attr_accessible :name, :public, :user_id, :user
  
end
