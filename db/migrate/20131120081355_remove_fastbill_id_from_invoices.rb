class RemoveFastbillIdFromInvoices < ActiveRecord::Migration
  def up
    remove_column :invoices, :fastbill_id
  end

  def down
    add_column :invoices, :fastbill_id, :string
  end
end
