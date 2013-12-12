class AddFieldsAndTablesForInvoice < ActiveRecord::Migration
  def change
    # add tables
    create_table :discounts do |t|
      t.string :title
      t.text  :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :percent
      t.integer :max_discounted_value_cents
      t.integer :num_of_discountable_articles

      t.timestamps
    end
    
    create_table :refunds do |t|
      t.string :reason
      t.text :description
      t.integer :transaction_id
      
      t.timestamps
    end
    
    # add columns
    add_column :articles, :discount_id, :integer
    add_column :transactions, :discount_id, :integer
    add_column :transactions, :discount_value_cents, :integer
    add_column :users, :fastbill_subscription_id, :integer
    add_column :users, :fastbill_id, :integer
    
    # add indices
    add_index :articles, :discount_id
    add_index :transactions, :discount_id
    add_index :refunds, :transaction_id
  end
end
