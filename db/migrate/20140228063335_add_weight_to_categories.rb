class AddWeightToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :weight, :integer
  end
end
