class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.float :amount
      t.integer :user_id
      t.integer :auction_id

      t.timestamps
    end
  end
end
