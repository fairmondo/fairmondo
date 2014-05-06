class CombineErroneousArticlesWithMassUploadArticles < ActiveRecord::Migration
  def up
    drop_table :erroneous_articles
    add_column :mass_upload_articles, :row_index , :integer
    add_column :mass_upload_articles, :validation_errors , :text
    add_column :mass_upload_articles, :article_csv , :text
  end

  def down
    create_table "erroneous_articles", :force => true do |t|
      t.integer  "mass_upload_id"
      t.integer  "row_index"
      t.text     "validation_errors"
      t.text     "article_csv"
      t.datetime "created_at",        :null => false
      t.datetime "updated_at",        :null => false
    end
    remove_column :mass_upload_articles, :row_index
    remove_column :mass_upload_articles, :validation_errors
    remove_column :mass_upload_articles, :article_csv
  end
end
