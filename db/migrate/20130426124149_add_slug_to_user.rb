class AddSlugToUser < ActiveRecord::Migration
  def up
    add_column :users, :slug, :string
    add_index :users, :slug, :unique => true
  end
  def down
    remove_column :users, :slug
  end
end
