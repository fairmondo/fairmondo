class CreateFfps < ActiveRecord::Migration
  def change
    create_table :ffps do |t|
      t.integer :price
      t.string :name
      t.string :surname
      t.string :email

      t.timestamps
    end
  end
end
