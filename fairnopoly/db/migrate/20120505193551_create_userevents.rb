class CreateUserevents < ActiveRecord::Migration
  def change
    create_table :userevents do |t|
      t.string :title
      t.string :kategory
      t.text :content

      t.timestamps
    end
  end
end
