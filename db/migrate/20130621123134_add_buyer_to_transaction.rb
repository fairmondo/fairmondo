class AddBuyerToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :buyer_id, :integer
  end
end
