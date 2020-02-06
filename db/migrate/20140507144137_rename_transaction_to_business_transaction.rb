class RenameTransactionToBusinessTransaction < ActiveRecord::Migration[4.2]
  def change
    drop_table :bids
    rename_column :ratings, :transaction_id, :business_transaction_id
    rename_column :refunds, :transaction_id, :business_transaction_id
    rename_table :transactions, :business_transactions
  end
end
