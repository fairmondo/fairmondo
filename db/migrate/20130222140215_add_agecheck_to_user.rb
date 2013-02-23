class AddAgecheckToUser < ActiveRecord::Migration
  def change
    add_column :users, :agecheck, :boolean
  end
end
