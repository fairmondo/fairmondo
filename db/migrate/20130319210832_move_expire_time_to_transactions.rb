class MoveExpireTimeToTransactions < ActiveRecord::Migration
  def change
    remove_column :auctions, :expire
    add_column :transactions, :expire, :datetime
  end


end
