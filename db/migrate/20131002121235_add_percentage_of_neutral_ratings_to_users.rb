class AddPercentageOfNeutralRatingsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :percentage_of_neutral_ratings, :float, default: 0.0
  end
end
