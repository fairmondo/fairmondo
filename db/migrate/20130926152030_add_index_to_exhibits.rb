class AddIndexToExhibits < ActiveRecord::Migration
  def change
    add_index :exhibits, :article_id
    add_index :exhibits, :related_article_id
  end
end
