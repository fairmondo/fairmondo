class BestPracticesClearUp < ActiveRecord::Migration
  def up
    drop_table :userevents
    drop_table :invitations

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
