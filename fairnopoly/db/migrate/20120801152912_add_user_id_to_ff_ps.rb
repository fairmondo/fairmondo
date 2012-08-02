class AddUserIdToFfPs < ActiveRecord::Migration
  def change
    add_column :ffps, :user_id, :integer

  end
end
