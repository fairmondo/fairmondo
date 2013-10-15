class RemoveInvoiceIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :invoice_id
  end
end
