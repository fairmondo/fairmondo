class AddSlugToAuction < ActiveRecord::Migration

  def up
    add_column :auctions, :slug, :string
    add_index :auctions, :slug, :unique => true
  end
  def down
    remove_column :auctions, :slug
  end

end
