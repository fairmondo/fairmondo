class RenameForClarification < ActiveRecord::Migration
  def up
    rename_column :articles, :calculated_corruption_cents, :calculated_fair_cents
  end

  def down
    rename_column :articles, :calculated_fair_cents, :calculated_corruption_cents
  end
end
