class RemoveUniqueHashFromCart < ActiveRecord::Migration
  def change
    remove_column :carts, :unique_hash, :string # I found out we can just use cookies.signed
  end
end
