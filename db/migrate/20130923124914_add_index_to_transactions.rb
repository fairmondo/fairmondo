class AddIndexToTransactions < ActiveRecord::Migration
  def change
    add_index :transactions, :seller_id
  end
end
