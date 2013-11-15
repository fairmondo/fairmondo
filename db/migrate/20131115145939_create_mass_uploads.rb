class CreateMassUploads < ActiveRecord::Migration
  def change
    create_table :mass_uploads do |t|
      t.integer :count
      t.integer :total_count

      t.timestamps
    end
  end
end
