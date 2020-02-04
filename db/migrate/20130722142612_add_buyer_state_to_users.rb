class AddBuyerStateToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :buyer_state, :string
  end
end
