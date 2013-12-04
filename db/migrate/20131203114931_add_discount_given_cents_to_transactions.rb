class AddDiscountGivenCentsToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :discount_given_cents, :integer, default: 0
  end
end
