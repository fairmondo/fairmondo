class AddAuditedToLibraries < ActiveRecord::Migration[4.2]
  def change
    add_column :libraries, :audited, :boolean, default: false
  end
end
