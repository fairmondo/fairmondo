class AuctionTransaction < Transaction

  attr_protected :max_bid
  attr_readonly :expire

  has_one :max_bid ,:class_name => 'Bid'
  has_many :bids

  validates_presence_of :expire
  #validate :validate_expire

  # other

  ### Comment back in when this is used and testable
  # def validate_expire
  #   return false unless self.expire
  #   if self.expire < 1.hours.from_now
  #     self.errors.add(:expire, "Expire time must be at least one hour in the future.")
  #     return false
  #   end
  #   if self.expire > 1.years.from_now
  #     self.errors.add(:expire, "Expire time must less than one year from now.")
  #     return false
  #   end
  #   return true
  # end

end