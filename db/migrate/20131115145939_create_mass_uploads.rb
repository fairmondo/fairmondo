class CreateMassUploads < ActiveRecord::Migration
  def change
    create_table :mass_uploads do |t|
      t.integer :article_count
      t.integer :total_article_count

      t.timestamps
    end
  end
end
