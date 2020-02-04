class AddBelboonTrackingTokenToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :belboon_tracking_token, :string
  end
end
