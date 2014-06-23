class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer  "cart_id",                                limit: 8
      t.integer  "business_transaction_id",                limit: 8
      t.integer  "requested_quantity"
      t.timestamps
    end
  end
end
