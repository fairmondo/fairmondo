class AddUserIdToUserEvents < ActiveRecord::Migration
  def change
    add_column :userevents, :user_id, :integer

  end
end
