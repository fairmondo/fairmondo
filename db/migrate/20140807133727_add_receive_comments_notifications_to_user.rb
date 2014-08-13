class AddReceiveCommentsNotificationsToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_comments_notification, :boolean
  end
end
