class AddActivatedToFfPs < ActiveRecord::Migration
  def change
    add_column :ffps, :activated, :boolean

  end
end
