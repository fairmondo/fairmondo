class RemoveActiveFromArticle < ActiveRecord::Migration
  def up
    remove_column :articles, :active
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
