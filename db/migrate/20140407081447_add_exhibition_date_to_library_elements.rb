class AddExhibitionDateToLibraryElements < ActiveRecord::Migration[4.2]
  def change
    add_column :library_elements, :exhibition_date, :datetime
  end
end
