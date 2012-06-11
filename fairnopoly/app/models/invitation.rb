class Invitation < ActiveRecord::Base
  has_one :user
  validates_presence_of :user, :name, :surname, :email, :relation, :trusted_1, :trusted_2
end
