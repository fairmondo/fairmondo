class Bid < ActiveRecord::Base
  has_one :transaction
  has_one :user
  monetize :price_cents
end
