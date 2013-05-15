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
