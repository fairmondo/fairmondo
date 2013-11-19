class AddCsvFileToMassUpload < ActiveRecord::Migration
  def change
    add_column :mass_uploads, :csv_file, :attachment
  end
end
