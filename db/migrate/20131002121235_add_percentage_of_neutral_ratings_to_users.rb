class AddPercentageOfNeutralRatingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :percentage_of_neutral_ratings, :float, default: 0.0
  end
end
