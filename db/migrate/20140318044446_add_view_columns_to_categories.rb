class AddViewColumnsToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :view_columns, :integer, default: 2
  end
end
