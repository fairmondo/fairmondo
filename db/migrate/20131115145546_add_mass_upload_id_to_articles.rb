class AddMassUploadIdToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :mass_upload_id, :integer
  end
end
