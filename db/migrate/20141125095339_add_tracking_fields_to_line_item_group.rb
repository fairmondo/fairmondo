class AddTrackingFieldsToLineItemGroup < ActiveRecord::Migration
  def change
    add_column :line_item_groups, :transport_state, :string, default: :pending
    add_column :line_item_groups, :payment_state, :string, default: :pending
  end
end
