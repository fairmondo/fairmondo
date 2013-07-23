class AddSellerStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seller_state, :string
  end
end
