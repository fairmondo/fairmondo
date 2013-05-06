class AddUidConfirmedToUser < ActiveRecord::Migration
  def change
    add_column :users, :uid_confirmed, :boolean
  end
end
