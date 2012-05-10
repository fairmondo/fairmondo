class Userevent < ActiveRecord::Base
  belongs_to :user
  belongs_to :appended_object, :polymorphic => true
  validates_presence_of :user, :event_type
  
  
end
