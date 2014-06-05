class AddUserIdToAddress < ActiveRecord::Migration
  change_table :addresses do |t|
    t.integer :user_id
  end
end
