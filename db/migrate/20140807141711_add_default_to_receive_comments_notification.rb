class AddDefaultToReceiveCommentsNotification < ActiveRecord::Migration
  def change
    change_column :users, :receive_comments_notification, :boolean, default: false
  end
end
