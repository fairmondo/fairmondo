class AddActiveToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :active, :boolean, :default => false
  end
end
