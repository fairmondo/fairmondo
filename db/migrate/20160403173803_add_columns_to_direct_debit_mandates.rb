class AddColumnsToDirectDebitMandates < ActiveRecord::Migration[4.2]
  def change
    add_column :direct_debit_mandates, :state, :string
    add_column :direct_debit_mandates, :activated_at, :datetime
    add_column :direct_debit_mandates, :last_used_at, :datetime
    add_column :direct_debit_mandates, :revoked_at, :datetime
  end
end
