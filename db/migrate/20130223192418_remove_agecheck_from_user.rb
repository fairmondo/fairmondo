class RemoveAgecheckFromUser < ActiveRecord::Migration
  def up
      remove_column :users, :privacy
      remove_column :users, :legal
      remove_column :users, :agecheck
  end

  def down
      add_column :users, :privacy, :boolean
      add_column :users, :legal, :boolean
      add_column :users, :agecheck, :boolean
  end
end
