class Bid < ActiveRecord::Base

  attr_accessible :price_cents
  attr_protected :user, :auction_transaction

  belongs_to :auction_transaction
  belongs_to :user
  monetize :price_cents

  # TODO
  # before_save :check_better
  validates_presence_of :user_id, :auction_transaction_id, :price_cents
  def check_better
    if self.auction.transaction.max_bid
      unless self.price_cents > self.auction_transaction.max_bid
        errors[:price_cents] << I18n.t("transaction.bid.smaller-than-prev")
      end
    else
      unless self.price_cents >= self.auction_transaction.auction.price_cents
        errors[:price_cents] <<  I18n.t("transaction.bid.smaller-than-init")
      end
    end

  end

end
