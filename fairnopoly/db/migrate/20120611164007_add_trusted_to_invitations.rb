class AddTrustedToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :trusted_1, :boolean

    add_column :invitations, :trusted_2, :boolean

  end
end
