class ChangeDefaultOfReceiveCommentsNotification < ActiveRecord::Migration
  def change
    change_column :users, :receive_comments_notification, :boolean, default: true
  end
end
