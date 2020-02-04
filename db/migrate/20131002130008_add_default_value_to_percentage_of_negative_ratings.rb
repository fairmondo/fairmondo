class AddDefaultValueToPercentageOfNegativeRatings < ActiveRecord::Migration[4.2]
  def up
    change_column :users, :percentage_of_negative_ratings, :float, :default => 0.0
  end

  def down
    change_column :users, :percentage_of_negative_ratings, :float, :default => nil
  end
end
