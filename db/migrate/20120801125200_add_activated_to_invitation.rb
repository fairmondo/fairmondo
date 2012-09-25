class AddActivatedToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :activated, :boolean

  end
end
