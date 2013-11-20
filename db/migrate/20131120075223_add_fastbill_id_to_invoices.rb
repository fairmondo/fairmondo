class AddFastbillIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :fastbill_id, :string
  end
end
