class RemoveQuantitySoldFromArticles < ActiveRecord::Migration[4.2]
  def up
    remove_column :articles, :quantity_sold
  end

  def down
    add_column :articles, :quantity_sold, :integer, default: 0
  end
end
