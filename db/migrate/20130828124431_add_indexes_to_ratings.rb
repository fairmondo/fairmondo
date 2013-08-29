class AddIndexesToRatings < ActiveRecord::Migration
  def change
    add_index :ratings, :transaction_id
    add_index :ratings, :rated_user_id
  end
end
