class AddAlternativeEmailsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :invoicing_email, :string,           default: '', null: false
    add_column :users, :order_notifications_email, :string, default: '', null: false
  end
end
