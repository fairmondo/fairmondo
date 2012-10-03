class Transaction < ActiveRecord::Base
  has_one :auction
  has_one :buyer ,:class_name => 'User'
end
