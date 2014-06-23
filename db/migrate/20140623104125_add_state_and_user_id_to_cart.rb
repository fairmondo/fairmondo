class AddStateAndUserIdToCart < ActiveRecord::Migration
  def change
    add_column :carts, :user_id, :integer,  limit: 8
    add_column :carts, :sold, :boolean
  end
end
