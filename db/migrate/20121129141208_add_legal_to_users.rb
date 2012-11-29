class AddLegalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :legal, :boolean
  end
end
