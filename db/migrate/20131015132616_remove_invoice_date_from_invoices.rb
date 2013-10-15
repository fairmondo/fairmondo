class RemoveInvoiceDateFromInvoices < ActiveRecord::Migration
  def up
    remove_column :invoices, :invoice_date
  end

  def down
    add_column :invoices, :invoice_date, :datetime
  end
end
