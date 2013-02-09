class AddIndicesForAuctionTemplates < ActiveRecord::Migration
  def up
    add_index :auctions, :auction_template_id
    add_index :auctions, [:id, :auction_template_id], :unique => true
  end

  def down
    remove_index :auctions, :auction_template_id
    remove_index :auctions, :column => [:id, :auction_template_id]
  end
end
