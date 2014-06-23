class AddStandardAddressIdToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :billing_address_id
    remove_column :users, :shipping_address_id
    add_column :users, :standard_address_id, :bigint
  end
end
