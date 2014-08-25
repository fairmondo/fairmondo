class AddAuditedToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :audited, :boolean, default: false
  end
end
