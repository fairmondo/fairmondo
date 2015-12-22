class AddAlternativeEmailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invoicing_email, :string,           default: '', null: false
    add_column :users, :order_notifications_email, :string, default: '', null: false
  end
end
