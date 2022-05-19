class AddNextDirectDebitMandateNumberToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :next_direct_debit_mandate_number, :integer, default: 1
  end
end
