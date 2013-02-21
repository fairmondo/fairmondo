class Transaction < ActiveRecord::Base
  has_one :auction
  attr_accessible :type, :max_bid
  has_one :buyer ,:class_name => 'User'
end
