class AddUserIdIndexToAddresses < ActiveRecord::Migration
  def change
    add_index :addresses, :user_id, name: :addresses_user_id_index
  end
end
