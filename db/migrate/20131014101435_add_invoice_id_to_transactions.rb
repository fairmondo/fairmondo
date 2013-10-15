class AddInvoiceIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :invoice_id, :integer, :references => :invoices
    add_index :transactions, :invoice_id
  end
end
