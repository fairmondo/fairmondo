class AddExhibitionDateToLibraryElements < ActiveRecord::Migration
  def change
    add_column :library_elements, :exhibition_date, :datetime
  end
end
