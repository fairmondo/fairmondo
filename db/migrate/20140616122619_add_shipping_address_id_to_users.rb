class AddShippingAddressIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shipping_address_id, :bigint
  end
end
