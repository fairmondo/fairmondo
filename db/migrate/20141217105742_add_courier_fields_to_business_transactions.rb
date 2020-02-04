class AddCourierFieldsToBusinessTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :business_transactions, :courier_emails_sent, :boolean, default: false
    add_column :business_transactions, :courier_emails_sent_at, :datetime, default: nil
  end
end
