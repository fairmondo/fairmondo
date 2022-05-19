class CreateErroneousArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :erroneous_articles do |t|
      t.integer :mass_upload_id
      t.integer :row_index
      t.text :validation_errors
      t.text :article_csv

      t.timestamps
    end
  end
end
