class AddRefundedFairAndRefundedFeeToBusinessTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :business_transactions, :refunded_fair, :boolean, default: false
    add_column :business_transactions, :refunded_fee, :boolean, default: false
  end
end
