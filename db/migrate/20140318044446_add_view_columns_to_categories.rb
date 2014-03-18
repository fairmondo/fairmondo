class AddViewColumnsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :view_columns, :integer, default: 2
  end
end
