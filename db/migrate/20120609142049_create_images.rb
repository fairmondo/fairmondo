class CreateImages < ActiveRecord::Migration
   def change
    create_table :images do |t|
      t.has_attached_file :image
      t.timestamps
    end
  end
end
