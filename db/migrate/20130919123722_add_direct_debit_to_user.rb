class AddDirectDebitToUser < ActiveRecord::Migration
  def change
    add_column :users, :direct_debit, :boolean, :default => false
  end
end
