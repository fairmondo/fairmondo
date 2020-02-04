class AddCounterCacheToCategories < ActiveRecord::Migration[4.2]
  def up
     add_column :categories, :children_count, :integer, :default => 0
  end

  def down
     remove_column :categories, :children_count
  end
end
