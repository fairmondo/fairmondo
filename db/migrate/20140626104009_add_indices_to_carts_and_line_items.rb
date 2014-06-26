class AddIndicesToCartsAndLineItems < ActiveRecord::Migration
  def change
    add_index :carts, ["user_id"], :name => "index_carts_on_user_id"
    add_index :line_item_groups, ["cart_id"], :name => "index_line_item_groups_on_cart_id"
    add_index :line_item_groups, ["user_id"], :name => "index_line_item_groups_on_user_id"
    add_index :line_items, ["line_item_group_id"], :name => "index_line_items_on_line_item_group_id"
    add_index :line_items, ["business_transaction_id"], :name => "index_line_items_on_business_transaction_id"
  end
end
