class AddNgoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ngo, :boolean, :default => false
  end
end
