class AddConditionToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :condition, :string

  end
end
