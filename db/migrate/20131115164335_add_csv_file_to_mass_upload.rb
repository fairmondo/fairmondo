class AddCsvFileToMassUpload < ActiveRecord::Migration
  def change
    add_attachment :mass_uploads, :file
  end
end
