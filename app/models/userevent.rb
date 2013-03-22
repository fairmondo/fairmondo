class Userevent < ActiveRecord::Base
  
  attr_accessible :user,:appended_object, :event_type
  
  belongs_to :user
  belongs_to :appended_object, :polymorphic => true
  validates_presence_of :user, :event_type


  
end
