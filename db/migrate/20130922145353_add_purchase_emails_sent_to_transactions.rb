class AddPurchaseEmailsSentToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :purchase_emails_sent, :boolean, default: false
  end
end
