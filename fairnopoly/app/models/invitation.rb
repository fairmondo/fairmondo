class Invitation < ActiveRecord::Base
  #has_one :user
  belongs_to :sender ,:class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :name, :surname, :email, :relation, :trusted_1, :trusted_2
end
