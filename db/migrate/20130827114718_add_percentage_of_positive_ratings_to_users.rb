class AddPercentageOfPositiveRatingsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :percentage_of_positive_ratings, :float
  end
end
