class AddIndicesToMassUploads < ActiveRecord::Migration
  def change
    add_index :articles, :mass_upload_id
    add_index :erroneous_articles, :mass_upload_id
    add_index :mass_uploads, :user_id
  end
end
