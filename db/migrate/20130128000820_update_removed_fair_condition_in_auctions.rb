class UpdateRemovedFairConditionInAuctions < ActiveRecord::Migration
  def up
    Auction.update_all("condition = 'new'","condition = 'fair'")
  end

  def down
  end
end
