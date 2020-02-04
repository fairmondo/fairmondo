class AddCsvFileToMassUpload < ActiveRecord::Migration[4.2]
  def change
    add_attachment :mass_uploads, :file
  end
end
