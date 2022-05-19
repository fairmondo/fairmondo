class AddSellerIdToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :seller_id, :integer
  end
end
