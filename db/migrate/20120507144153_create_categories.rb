class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :desc
      t.integer :level
      t.integer :parent_id

      t.timestamps
    end
  end
end
