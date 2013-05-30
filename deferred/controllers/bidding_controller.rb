#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class BiddingController < ApplicationController

  # under construction - no routes for this

  before_filter :authenticate_user!
  def bid
    begin
    if params[:id]
      Transaction.transaction do
        auction_transaction = Transaction.find params[:id], :lock => true
        bid = Bid.new :transaction => auction_transaction , :user => current_user, :price_cents => params[:price_cents]
        bid.save
        auction_transaction.buyer = current_user
        auction_transaction.max_bid = bid
        transaction.save

      end
      redirect_to auction_transaction.article , :notice => (I18n.t 'transaction.bid.success')
    end
    rescue
      redirect_to auction_transaction.article , :notice => (I18n.t 'transaction.bid.failure' + bid.errors.first )
    end
  end
end