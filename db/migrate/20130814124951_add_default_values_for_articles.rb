class AddDefaultValuesForArticles < ActiveRecord::Migration[4.2]
  def up
    change_column :articles, :quantity, :integer, :default => 1
    change_column :articles, :price_cents, :integer, :default => 100
    change_column :articles, :friendly_percent, :integer, :default => 0, :limit => 3
  end

  def down
    change_column :articles, :quantity, :integer
    change_column :articles, :price_cents, :integer
    change_column :articles, :friendly_percent, :integer, :limit => 3
  end
end
