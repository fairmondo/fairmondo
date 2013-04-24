class RemoveColorAndSize < ActiveRecord::Migration
  # ref #231
  def up
    remove_column :auctions, :color
    remove_column :auctions, :size
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
