class AddFastbillSubscriptionIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fastbill_subscription_id, :string
  end
end
