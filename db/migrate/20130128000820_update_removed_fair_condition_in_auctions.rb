class UpdateRemovedFairConditionInAuctions < ActiveRecord::Migration
  class Auction < ActiveRecord::Base

  end
  def up
    Auction.reset_column_information
    Auction.unscoped.update_all("condition = 'new'","condition = 'fair'")
  end

  def down
  end
end
