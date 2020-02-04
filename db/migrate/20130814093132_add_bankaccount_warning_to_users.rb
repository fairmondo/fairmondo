class AddBankaccountWarningToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :bankaccount_warning, :boolean
  end
end
