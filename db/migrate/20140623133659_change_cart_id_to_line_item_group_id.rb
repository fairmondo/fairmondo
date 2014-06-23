class ChangeCartIdToLineItemGroupId < ActiveRecord::Migration
  def change
    rename_column :line_items, :cart_id, :line_item_group_id
  end
end
