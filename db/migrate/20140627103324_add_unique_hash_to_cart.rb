class AddUniqueHashToCart < ActiveRecord::Migration
  def change
    add_column :carts, :unique_hash, :string, limit: 40
  end
end
