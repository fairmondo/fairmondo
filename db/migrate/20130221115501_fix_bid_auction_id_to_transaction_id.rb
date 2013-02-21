class FixBidAuctionIdToTransactionId < ActiveRecord::Migration
  
  def up
    remove_column :bids,:auction_id
    add_column :bids,:auction_transaction_id, :integer
  end

  def down
    add_column :bids,:auction_id,:integer
    remove_column :bids,:auction_transaction_id
  end
end
