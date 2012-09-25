class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :max_bid
      t.string :type

      t.timestamps
    end
  end
end
