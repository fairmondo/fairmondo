class AddExhibitionNameToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :exhibition_name, :string
  end
end
