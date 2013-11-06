class AddPercentageOfPositiveRatingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :percentage_of_positive_ratings, :float
  end
end
