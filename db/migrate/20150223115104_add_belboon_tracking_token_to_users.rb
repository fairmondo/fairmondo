class AddBelboonTrackingTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :belboon_tracking_token, :string
  end
end
