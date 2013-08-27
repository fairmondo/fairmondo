class AddPercentageOfNegativeRatingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :percentage_of_negative_ratings, :float
  end
end
