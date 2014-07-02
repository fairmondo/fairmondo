class AddUnifiedPaymentMethodToLineItemGroups < ActiveRecord::Migration
  def change
    add_column :line_item_groups, :unified_payment_method, :string
  end
end
