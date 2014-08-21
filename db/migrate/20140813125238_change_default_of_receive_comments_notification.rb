class ChangeDefaultOfReceiveCommentsNotification < ActiveRecord::Migration
  def change
    change_column :users, :receive_comments_notification, :boolean, default: true
    User.reset_column_information
    User.find_each do |user|
      user.update_column :receive_comments_notification, true
    end
  end
end
