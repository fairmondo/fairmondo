class CreateNotices < ActiveRecord::Migration[4.2]
  def change
    create_table :notices do |t|
      t.text :message
      t.boolean :open
      t.integer :user_id
      t.string :path
      t.string :color
      t.timestamps
    end
  end
end
