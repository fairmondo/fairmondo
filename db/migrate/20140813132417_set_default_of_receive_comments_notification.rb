class SetDefaultOfReceiveCommentsNotification < ActiveRecord::Migration
  def change
    User.set_comment_notification_defaults
  end
end
