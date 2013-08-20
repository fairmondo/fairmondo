class AddTitleCacheToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :title_image_thumb_path, :string
  end
end
