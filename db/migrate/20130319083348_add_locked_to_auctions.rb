class AddLockedToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :locked, :boolean, :default => false
  end
end
