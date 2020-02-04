class AddPercentageOfNegativeRatingsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :percentage_of_negative_ratings, :float
  end
end
