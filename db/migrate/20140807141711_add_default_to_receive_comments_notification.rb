class AddDefaultToReceiveCommentsNotification < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :receive_comments_notification, :boolean, default: false
  end
end
