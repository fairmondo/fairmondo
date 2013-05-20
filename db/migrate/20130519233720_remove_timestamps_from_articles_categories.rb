class RemoveTimestampsFromArticlesCategories < ActiveRecord::Migration
  def up
    remove_index :articles_categories, :column => ["article_id", "category_id"]
    remove_column :articles_categories, :created_at
    remove_column :articles_categories, :updated_at
    add_index :articles_categories, ["article_id", "category_id"] , :name => "articles_category_index"
    #index name too long sqlite
  end

  def down
    add_column :articles_categories, :updated_at, :string
    add_column :articles_categories, :created_at, :string
  end
end
