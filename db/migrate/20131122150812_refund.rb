class Refund < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.integer :transaction_id
      t.string :reason
      t.text :description
 
      t.timestamps
    end
  end
end
