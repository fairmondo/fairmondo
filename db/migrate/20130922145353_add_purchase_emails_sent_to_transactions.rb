class AddPurchaseEmailsSentToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :purchase_emails_sent, :boolean, default: false
  end
end
