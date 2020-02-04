class AddSellerStateToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :seller_state, :string
  end
end
