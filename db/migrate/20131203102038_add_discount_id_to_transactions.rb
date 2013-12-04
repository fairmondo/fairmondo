class AddDiscountIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :discount_id, :integer
  end
end
