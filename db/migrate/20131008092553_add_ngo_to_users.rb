class AddNgoToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :ngo, :boolean, :default => false
  end
end
