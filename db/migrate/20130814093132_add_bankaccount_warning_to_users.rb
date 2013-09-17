class AddBankaccountWarningToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bankaccount_warning, :boolean
  end
end
