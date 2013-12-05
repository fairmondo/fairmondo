class ChangeMassUploadProgressAttributes < ActiveRecord::Migration
  def up
    remove_column :mass_uploads, :character_count
    rename_column :mass_uploads, :article_count, :row_count
  end

  def down
    add_column :mass_uploads, :character_count, :integer,  :default => 0
    rename_column :mass_uploads, :row_count, :article_count
  end
end
