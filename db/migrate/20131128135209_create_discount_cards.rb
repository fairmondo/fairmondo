class CreateDiscountCards < ActiveRecord::Migration
  def change
    create_table :discount_cards do |t|
      t.integer :user_id
      t.integer :discount_id
      t.integer :value_cents
      t.integer :num_of_articles

      t.timestamps
    end
  end
end
