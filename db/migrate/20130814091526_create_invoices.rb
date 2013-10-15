class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.datetime :due_date
      t.string :state

      t.timestamps
    end
    add_index :invoices, :user_id
  end
end
