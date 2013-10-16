class RemoveTotalFeeCentsFromInvoices < ActiveRecord::Migration
  def up
    remove_column :invoices, :total_fee_cents
  end

  def down
    add_column :invoices, :total_fee_cents, :integer
  end
end
