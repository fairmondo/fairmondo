class ChangeDefaultSoldOfCarts < ActiveRecord::Migration
  def change
    change_column :carts, :sold, :boolean, default: false
  end
end
