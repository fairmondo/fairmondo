class AddInvoiceDateToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :invoice_date, :datetime
  end
end
