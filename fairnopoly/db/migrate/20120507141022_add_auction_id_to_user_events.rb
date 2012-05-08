class AddAuctionIdToUserEvents < ActiveRecord::Migration
  def change
    add_column :userevents, :auction_id, :integer

  end
end
