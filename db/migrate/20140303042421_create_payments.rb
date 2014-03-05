class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :pay_key, :state
      t.text :error, :last_ipn
      t.integer :transaction_id
      t.timestamps
    end

    add_index :payments, :transaction_id
  end
end
