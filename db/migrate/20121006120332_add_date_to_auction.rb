class AddDateToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :expire, :datetime
  end
end
