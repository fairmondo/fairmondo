class AddTitleOptionToImages < ActiveRecord::Migration[4.2]
  def change
    add_column  :images, :is_title, :boolean
  end
end
