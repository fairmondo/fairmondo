#
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class Bid < ActiveRecord::Base

  attr_accessible :price_cents
  attr_protected :user, :auction_transaction

  belongs_to :auction_transaction
  belongs_to :user
  monetize :price_cents

  # TODO
  # before_save :check_better
  validates_presence_of :user_id, :auction_transaction_id, :price_cents

  ### Comment back in when this is used and testable
  # def check_better
  #   if self.article.transaction.max_bid
  #     unless self.price_cents > self.auction_transaction.max_bid
  #       errors[:price_cents] << I18n.t("transaction.bid.smaller-than-prev")
  #     end
  #   else
  #     unless self.price_cents >= self.auction_transaction.article.price_cents
  #       errors[:price_cents] <<  I18n.t("transaction.bid.smaller-than-init")
  #     end
  #   end
  # end

end
