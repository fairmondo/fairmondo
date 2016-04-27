class AddDirectDebitExemptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :direct_debit_exemption, :boolean, default: false
  end
end
