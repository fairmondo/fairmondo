class CreateReachedGoals < ActiveRecord::Migration
  def change
    create_table :reached_goals do |t|
      t.integer :value_1
      t.integer :value_2

      t.timestamps
    end
  end
end
