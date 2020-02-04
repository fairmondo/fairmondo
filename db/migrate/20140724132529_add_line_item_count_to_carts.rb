class AddLineItemCountToCarts < ActiveRecord::Migration[4.2]
  def change
    add_column :carts, :line_item_count, :integer, default: 0, nil: false
  end
end
