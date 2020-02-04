class AddIndexToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_index :transactions, :seller_id
  end
end
