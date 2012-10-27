class Invitation < ActiveRecord::Base
  
  validate :validate_sender
  
  def validate_sender
    if self.sender && self.sender.trustcommunity
      return true
    else
      return false
    end
  end
  
  #has_one :user
  belongs_to :sender ,:class_name => 'User', :foreign_key => 'user_id'
  #belongs_to :relation ,:class_name => 'UserRelation', :foreign_key => 'user_relation'
   
  validates_presence_of :name, :email, :relation, :trusted_1, :trusted_2
  
end
