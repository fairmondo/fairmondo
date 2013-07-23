class AddBuyerStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :buyer_state, :string
  end
end
