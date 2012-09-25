class AddInvitorIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :invitor_id, :integer

  end
end
