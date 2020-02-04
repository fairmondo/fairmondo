class AddIndexToExhibits < ActiveRecord::Migration[4.2]
  def change
    add_index :exhibits, :article_id
    add_index :exhibits, :related_article_id
  end
end
