class AddTotalFeeCentsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :total_fee_cents, :integer
  end
end
