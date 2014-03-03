class ChangeImageableToSti < ActiveRecord::Migration
  def up
    rename_column :images, :imageable_type, :type
    Image.update_all("type = type || 'Image'")
  end

  def down
    rename_column :images, :type, :imageable_type
  end
end
