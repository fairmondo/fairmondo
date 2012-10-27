class ChangeNameFromUserToForename < ActiveRecord::Migration
  def up
    rename_column :users, :name, :forename
  end

  def down
    rename_column :users, :forename, :name
  end
end
