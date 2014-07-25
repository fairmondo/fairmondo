class AddLineItemCountToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :line_item_count, :integer, default: 0, nil: false
  end
end
