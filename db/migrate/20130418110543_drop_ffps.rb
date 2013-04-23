class DropFfps < ActiveRecord::Migration
  def up
    drop_table :ffps
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
