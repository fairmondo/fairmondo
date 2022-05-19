class DropSettings < ActiveRecord::Migration[4.2]
  def change
    drop_table :settings
  end


end
