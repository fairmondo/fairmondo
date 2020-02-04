class AddDirectDebitExemptionToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :direct_debit_exemption, :boolean, default: false
  end
end
