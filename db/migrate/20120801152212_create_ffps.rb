class CreateFfps < ActiveRecord::Migration
  def change
    create_table :ffps do |t|
      t.integer :price
      

      t.timestamps
    end
  end
end
