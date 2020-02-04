class AddStateToMassUpload < ActiveRecord::Migration[4.2]
  def change
    add_column :mass_uploads, :state, :string
  end
end
