class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :rating
      t.text :text
      t.integer :transaction_id
      t.integer :rated_user_id

      t.timestamps
    end
  end
end
