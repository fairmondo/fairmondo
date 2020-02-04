class AddDirectDebitToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :direct_debit, :boolean, :default => false
  end
end
