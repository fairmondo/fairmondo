class AddRefundedFairAndRefundedFeeToBusinessTransactions < ActiveRecord::Migration
  def change
    add_column :business_transactions, :refunded_fair, :boolean, default: false
    add_column :business_transactions, :refunded_fee, :boolean, default: false
  end
end
