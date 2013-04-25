class AddConditionExtraToAuctions < ActiveRecord::Migration
def change
    add_column :auctions, :condition_extra, :string

  end
end
