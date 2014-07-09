class AddBillingAddressIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :billing_address_id, :bigint
  end
end
