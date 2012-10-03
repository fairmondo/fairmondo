class Transaction < ActiveRecord::Base
  has_one :auction
end
