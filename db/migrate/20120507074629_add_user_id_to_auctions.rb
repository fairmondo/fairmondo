class AddUserIdToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :user_id, :integer

  end
end
