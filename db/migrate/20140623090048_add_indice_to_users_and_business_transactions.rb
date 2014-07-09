class AddIndiceToUsersAndBusinessTransactions < ActiveRecord::Migration
  def change
    add_index :users, :standard_address_id, name: 'standard_user_address'
    add_index :business_transactions, :shipping_address_id, name: 'bt_shipping_addresses'
    add_index :business_transactions, :billing_address_id, name: 'bt_billing_addresses'
  end
end
