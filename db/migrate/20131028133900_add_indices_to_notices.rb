class AddIndicesToNotices < ActiveRecord::Migration
  def change
    add_index :notices, :user_id
  end
end
