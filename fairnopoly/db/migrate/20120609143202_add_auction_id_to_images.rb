class AddAuctionIdToImages < ActiveRecord::Migration
  def change
    add_column :images, :auction_id, :integer
  end
end
