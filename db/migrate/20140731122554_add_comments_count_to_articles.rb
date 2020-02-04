class AddCommentsCountToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :comments_count, :integer, nil: false, default: 0
  end
end
