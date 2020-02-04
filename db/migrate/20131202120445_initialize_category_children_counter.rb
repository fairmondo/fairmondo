class InitializeCategoryChildrenCounter < ActiveRecord::Migration[4.2]
  def up
    Category.all.each do |c|
      Category.update_counters c.id, :children_count => c.children.count
    end
  end

  def down
    # nothing
  end
end
