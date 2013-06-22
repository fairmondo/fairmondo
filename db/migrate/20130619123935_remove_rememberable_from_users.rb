class RemoveRememberableFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :remember_created_at
  end

  def down
    add_column :users, :remember_created_at, :datetime
  end
end
