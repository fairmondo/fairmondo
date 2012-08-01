class AddActivationKeyToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :activation_key, :string

  end
end
