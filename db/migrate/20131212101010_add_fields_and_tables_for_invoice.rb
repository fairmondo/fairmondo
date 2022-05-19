class AddFieldsAndTablesForInvoice < ActiveRecord::Migration[4.2]
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

    # add columns
    add_column :articles, :discount_id, :integer
    add_column :transactions, :discount_id, :integer
    add_column :transactions, :discount_value_cents, :integer
    add_column :users, :fastbill_subscription_id, :integer
    add_column :users, :fastbill_id, :integer

    # add indices
    add_index :articles, :discount_id
    add_index :transactions, :discount_id
  end
end
