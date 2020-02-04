class AddReceiveCommentsNotificationsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :receive_comments_notification, :boolean
  end
end
