class ChangeRequestedQuantityDefaultInLineItems < ActiveRecord::Migration
  def change
    change_column :line_items, :requested_quantity, :integer, default: 1
  end
end
