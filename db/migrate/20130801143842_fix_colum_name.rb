class FixColumName < ActiveRecord::Migration
  def change
    rename_column :feedbacks, :type, :variety
  end
end
