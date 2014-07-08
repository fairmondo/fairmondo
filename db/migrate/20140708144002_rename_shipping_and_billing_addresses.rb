class RenameShippingAndBillingAddresses < ActiveRecord::Migration
  def change
    rename_column :line_item_groups, :shipping_address_id, :transport_address_id
    rename_column :line_item_groups, :billing_address_id, :payment_address_id
  end
end
