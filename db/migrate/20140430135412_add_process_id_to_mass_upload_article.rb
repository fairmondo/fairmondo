class AddProcessIdToMassUploadArticle < ActiveRecord::Migration
  def change
    add_column :mass_upload_articles, :process_identifier, :string
    add_index "mass_upload_articles", ["row_index"], :name => "index_mass_upload_articles_on_row_index"
    add_index "mass_upload_articles", ["row_index","mass_upload_id"], :name => "index_mass_upload_articles_on_row_index_and_mass_upload_id"
  end
end
