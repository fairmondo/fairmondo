class AddStateToMassUpload < ActiveRecord::Migration
  def change
    add_column :mass_uploads, :state, :string
  end
end
