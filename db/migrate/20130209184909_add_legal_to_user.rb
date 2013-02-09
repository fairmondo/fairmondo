class AddLegalToUser < ActiveRecord::Migration
  def change
    add_column :users, :terms, :text
    add_column :users, :cancellation, :text
    add_column :users, :about, :text
  end
end
