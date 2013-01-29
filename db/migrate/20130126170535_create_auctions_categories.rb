class CreateAuctionsCategories < ActiveRecord::Migration
  def change
    create_table :auctions_categories do |t|
      t.integer :category_id
      t.integer :auction_id

      t.timestamps
    end
  end
end
