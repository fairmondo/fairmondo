class Ffp < ActiveRecord::Base
  
  #has_one :user
  belongs_to :donator ,:class_name => 'User', :foreign_key => 'user_id'
  #belongs_to :relation ,:class_name => 'UserRelation', :foreign_key => 'user_relation'
   
  validates_presence_of :price
  
   validates_numericality_of :price, 
    :less_than_or_equal_to => 500, 
    :greater_than_or_equal_to => 10, 
    :only_integer => true
  
end
