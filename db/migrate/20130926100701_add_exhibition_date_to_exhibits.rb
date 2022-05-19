class AddExhibitionDateToExhibits < ActiveRecord::Migration[4.2]
  def up
    add_column :exhibits, :exhibition_date, :datetime
  end
  def down
    remove_column :exhibits, :exhibition_date
  end
end
