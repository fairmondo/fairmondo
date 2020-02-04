class AddVerificationToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :verified, :boolean
  end
end
