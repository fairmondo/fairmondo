class AddUnconfirmedMailToUsers < ActiveRecord::Migration
  def up

    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable

  end

  def down
    remove_column :users, :unconfirmed_email # Only if using reconfirmable
  end
end
