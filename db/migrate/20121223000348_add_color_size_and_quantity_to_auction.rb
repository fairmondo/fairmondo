class AddColorSizeAndQuantityToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :color, :string
    add_column :auctions, :size, :string
    add_column :auctions, :quantity, :integer
  end
end
