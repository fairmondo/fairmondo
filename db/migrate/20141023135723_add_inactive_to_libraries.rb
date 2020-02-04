class AddInactiveToLibraries < ActiveRecord::Migration[4.2]
  def change
    add_column :library_elements, :inactive, :boolean, default: false
  end
end
