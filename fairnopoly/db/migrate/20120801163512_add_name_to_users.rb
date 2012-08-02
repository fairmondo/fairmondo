class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string

    add_column :users, :surname, :string

  end
end
