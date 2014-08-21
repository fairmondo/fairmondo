class AddCommentsCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :comments_count, :integer, nil: false, default: 0
  end
end
