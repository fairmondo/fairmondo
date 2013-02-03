class UpdateCategoriesAndAuctionsForAwesomeNestedSet < ActiveRecord::Migration
  def up
    Auction.unscoped.all.each do |auction|
      AuctionsCategory.create(:auction_id => auction.id, :category_id => auction.category_id)
    end
    
    add_column :categories, :lft, :integer
    add_column :categories, :rgt, :integer
    add_column :categories, :depth, :integer
    
    Category.update_all("parent_id = NULL","parent_id = 0")
    
    Category.rebuild!
    
    remove_column :auctions, :category_id
    remove_column :auctions, :alt_category_id_1
    remove_column :auctions, :alt_category_id_2
  end

  def down
    remove_column :categories, :lft
    remove_column :categories, :rgt
    remove_column :categories, :depth
    
    add_column :auctions, :category_id, :integer
    add_column :auctions, :alt_category_id_1, :integer
    add_column :auctions, :alt_category_id_2, :integer
    
    AuctionsCategory.all.each do |auctions_category|
      Auction.unscoped.find(auctions_category.auction_id).update_attribute(:category_id, auctions_category.category_id)
    end    
    Category.update_all("parent_id = 0","parent_id IS NULL")
  end
end
