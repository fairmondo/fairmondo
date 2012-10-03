class AddAuctionIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :auction_id, :integer
  end
end
