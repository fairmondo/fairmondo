class AddIndexesToRatings < ActiveRecord::Migration[4.2]
  def change
    add_index :ratings, :transaction_id
    add_index :ratings, :rated_user_id
  end
end
