class CreateDiscounts < ActiveRecord::Migration
  def change
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
  end
end
