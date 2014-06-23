class CreateLineItemGroups < ActiveRecord::Migration
  def change
    create_table :line_item_groups do |t|
      t.text :message
      t.integer :cart_id, limit:8
      t.boolean :tos_accepted
      t.integer :user_id, limit:8
      t.boolean :unified_transport
      t.boolean :unified_payment

      t.timestamps
    end
  end
end
