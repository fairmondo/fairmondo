class AddIndicesToNotices < ActiveRecord::Migration[4.2]
  def change
    add_index :notices, :user_id
  end
end
