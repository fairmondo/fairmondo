class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :due_date
      t.string :state
      t.boolean :paid
      t.integer :article_id

      t.timestamps
    end
  end
end
