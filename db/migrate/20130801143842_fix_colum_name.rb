class FixColumName < ActiveRecord::Migration[4.2]
  def change
    rename_column :feedbacks, :type, :variety
  end
end
