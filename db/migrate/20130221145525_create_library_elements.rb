class CreateLibraryElements < ActiveRecord::Migration
  def change
    create_table :library_elements do |t|
      t.integer :auction_id
      t.integer :library_id

      t.timestamps
    end
  end
end
