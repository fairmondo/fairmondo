class AddMassUploadIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :mass_upload_id, :integer
  end
end
