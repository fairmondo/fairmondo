class AddTitleOptionToImages < ActiveRecord::Migration
  def change
    add_column  :images, :is_title, :boolean
  end
end
