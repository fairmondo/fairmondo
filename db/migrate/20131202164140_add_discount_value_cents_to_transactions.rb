class AddDiscountValueCentsToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :discount_value_cents, :integer
  end
end
