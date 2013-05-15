class Transaction < ActiveRecord::Base
  has_one :article
  attr_accessible :type
end
