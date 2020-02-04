class AddSlugToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :slug, :string, unique: true
    add_index :categories, :slug, unique: true
  end
end
