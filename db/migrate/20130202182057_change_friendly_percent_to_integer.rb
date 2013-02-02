class ChangeFriendlyPercentToInteger < ActiveRecord::Migration
  def up
    change_column :auctions, :friendly_percent, :integer
  end

  def down
    change_column :auctions, :friendly_percent, :decimal, :precision => 3, :scale => 1
  end
end
