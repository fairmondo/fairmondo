class AddInvoiceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invoice_id, :integer
  end
end
