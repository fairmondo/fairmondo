class Transaction < ActiveRecord::Base
  has_one :auction
  attr_accessible :type
end
