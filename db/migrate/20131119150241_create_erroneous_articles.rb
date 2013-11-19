class CreateErroneousArticles < ActiveRecord::Migration
  def change
    create_table :erroneous_articles do |t|
      t.integer :mass_upload_id
      t.text :validation_errors
      t.text :article_csv

      t.timestamps
    end
  end
end
