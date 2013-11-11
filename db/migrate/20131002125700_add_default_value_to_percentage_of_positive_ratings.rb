class AddDefaultValueToPercentageOfPositiveRatings < ActiveRecord::Migration
  def up
    change_column :users, :percentage_of_positive_ratings, :float, :default => 0.0
  end

  def down
    change_column :users, :percentage_of_positive_ratings, :float, :default => nil
  end
end
