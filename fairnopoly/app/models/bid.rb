class Bid < ActiveRecord::Base
  has_one :auction
  has_one :user
end
