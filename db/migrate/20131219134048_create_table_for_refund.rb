class CreateTableForRefund < ActiveRecord::Migration
  create_table :refunds do |t|
    t.string :reason
    t.text :description
    t.integer :transaction_id

    t.timestamps
  end

  add_index :refunds, :transaction_id
end
