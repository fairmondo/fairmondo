class RemoveSmallAndPreciousEditionFromArticles < ActiveRecord::Migration
  def up
    remove_column :articles, :small_and_precious_edition
  end

  def down
    add_column :articles, :small_and_precious_edition, :integer
  end
end
