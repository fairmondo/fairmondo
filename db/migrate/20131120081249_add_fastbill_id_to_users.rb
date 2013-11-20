class AddFastbillIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fastbill_id, :string
  end
end
