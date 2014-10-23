class AddInactiveToLibraries < ActiveRecord::Migration
  def change
    add_column :library_elements, :inactive, :boolean, default: false
  end
end
