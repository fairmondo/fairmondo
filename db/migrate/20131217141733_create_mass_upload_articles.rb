class CreateMassUploadArticles < ActiveRecord::Migration
  def change
    create_table :mass_upload_articles do |t|
      t.integer :mass_upload_id
      t.integer :article_id
      t.string :action

      t.timestamps
    end
    add_index :mass_upload_articles, :mass_upload_id
    add_index :mass_upload_articles, :article_id

    remove_column :articles, :mass_upload_id
    remove_column :articles, :activation_action
  end
end
