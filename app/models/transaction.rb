class Transaction < ActiveRecord::Base
  belongs_to :auction
  has_one :buyer ,:class_name => 'User'
  validates_presence_of :auction
end
