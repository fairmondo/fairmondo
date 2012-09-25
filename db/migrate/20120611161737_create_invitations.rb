class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :relation
      t.integer :user_id

      t.timestamps
    end
  end
end
