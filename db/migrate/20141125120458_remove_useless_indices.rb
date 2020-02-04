class RemoveUselessIndices < ActiveRecord::Migration[4.2]
  def up
    remove_index :articles, name: :index_articles_on_discount_id
    remove_index :articles, name: :index_articles_on_original_id
    remove_index :articles, name: :index_articles_on_friendly_percent_organisation_id
    remove_index :articles, name: :text_pattern_index_on_slug
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
