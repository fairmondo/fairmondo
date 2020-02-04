class AddExhibitionNameToLibrary < ActiveRecord::Migration[4.2]
  def change
    add_column :libraries, :exhibition_name, :string
  end
end
