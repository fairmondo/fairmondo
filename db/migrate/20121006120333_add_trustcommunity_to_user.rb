class AddTrustcommunityToUser < ActiveRecord::Migration
  def change
    add_column :users, :trustcommunity, :boolean
  end
end
