class AddOriginalIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :original_id, :integer, limit: 8
    add_index :articles, [:original_id]
  end
end
