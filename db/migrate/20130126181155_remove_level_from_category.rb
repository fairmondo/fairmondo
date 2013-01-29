class RemoveLevelFromCategory < ActiveRecord::Migration
  def up
    remove_column :categories, :level
  end

  def down
    add_column :categories, :level, :integer
  end
end
