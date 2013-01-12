class AddFriendlyPercentToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :friendly_percent, :decimal, :precision => 3, :scale => 1
    add_column :auctions, :friendly_percent_organisation, :text
  end
end
