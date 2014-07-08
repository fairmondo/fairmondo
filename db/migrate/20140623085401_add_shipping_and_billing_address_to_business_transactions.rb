class AddShippingAndBillingAddressToBusinessTransactions < ActiveRecord::Migration
  def change
    add_column :business_transactions, :shipping_address_id, :bigint
    add_column :business_transactions, :billing_address_id, :bigint
  end
end
