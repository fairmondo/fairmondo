class AddOriginalIdToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :original_id, :integer, limit: 8
    add_index :articles, [:original_id]
  end
end
