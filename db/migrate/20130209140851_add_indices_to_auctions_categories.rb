class AddIndicesToAuctionsCategories < ActiveRecord::Migration
  def up
    add_index :auctions_categories, :category_id
    add_index :auctions_categories, :auction_id
    add_index :auctions_categories, [:auction_id, :category_id], :unique => true
  end

  def down
    remove_index :auctions_categories, :category_id
    remove_index :auctions_categories, :auction_id
    remove_index :auctions_categories, :column => [:auction_id, :category_id]
  end
end
