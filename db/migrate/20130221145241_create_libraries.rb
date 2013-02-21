class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :name
      t.boolean :public
      t.integer :user_id
      t.timestamps
    end
  end
end
