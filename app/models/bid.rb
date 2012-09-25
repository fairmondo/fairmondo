class Bid < ActiveRecord::Base
  has_one :transaction
  has_one :user
end
