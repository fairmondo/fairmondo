class CreateDirectDebitMandates < ActiveRecord::Migration[4.2]
  def change
    create_table :direct_debit_mandates do |t|
      t.string :reference
      t.references :user, index: true

      t.timestamps
    end
  end
end
