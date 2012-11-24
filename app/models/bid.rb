class Bid < ActiveRecord::Base
  has_one :transaction
  has_one :user
  monetize :price_cents

  before_save :check_better
  validates_presence_of :user, :transaction, :price_cents
  def check_better
    if self.transaction.max_bid
      unless self.price_cents > self.transaction.max_bid
      #TODO undefined method `add_to_base' for #<ActiveModel::Errors:0x007fdbcfea8ff0>
      #errors.add_to_base I18n.t("transaction.bid.smaller-than-prev")
      return false
      end
    else
      unless self.price_cents >= self.transaction.auction.price_cents
      #TODO undefined method `add_to_base' for #<ActiveModel::Errors:0x007fdbcfea8ff0>
      #errors.add_to_base I18n.t("transaction.bid.smaller-than-init")
      end
    end

  end

end
