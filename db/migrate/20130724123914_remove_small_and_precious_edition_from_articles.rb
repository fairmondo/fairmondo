class RemoveSmallAndPreciousEditionFromArticles < ActiveRecord::Migration[4.2]
  def up
    remove_column :articles, :small_and_precious_edition
  end

  def down
    add_column :articles, :small_and_precious_edition, :integer
  end
end
