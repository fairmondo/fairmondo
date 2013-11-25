class RemoveRequestedRefundFromTransactions < ActiveRecord::Migration
  def up
    remove_column :transactions, :requested_refund
  end

  def down
    add_column :transactions, :requested_refund, :string
  end
end
