class AddRequestedRefundToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :requested_refund, :boolean, default: false
    add_column :transactions, :refund_reason, :string
    add_column :transactions, :refund_explanation, :text
  end
end
