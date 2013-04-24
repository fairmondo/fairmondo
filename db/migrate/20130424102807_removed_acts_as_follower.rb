class RemovedActsAsFollower < ActiveRecord::Migration
  def up
    drop_table :follows
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
