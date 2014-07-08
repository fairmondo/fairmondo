class MoveBillingAndShippingAddressToLineItemGroup < ActiveRecord::Migration
  class BusinessTransaction < ActiveRecord::Base
    belongs_to :line_item_group
  end

  class LineItemGroup < ActiveRecord::Base
    has_many :business_transactions
  end

  def up
    add_column :line_item_groups, :shipping_address_id, :integer, limit:8
    add_column :line_item_groups, :billing_address_id, :integer, limit:8
    BusinessTransaction.find_each  do |bt|
      bt.line_item_group.update_attribute :shipping_address_id, bt.shipping_address_id
      bt.line_item_group.update_attribute :billing_address_id, bt.billing_address_id
    end
    remove_column :business_transactions,  :shipping_address_id
    remove_column :business_transactions,  :billing_address_id
  end
end
