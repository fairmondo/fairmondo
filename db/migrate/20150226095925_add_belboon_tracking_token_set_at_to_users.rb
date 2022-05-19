class AddBelboonTrackingTokenSetAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :belboon_tracking_token_set_at, :datetime
  end
end
