class AddBuyDateToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :buy_date, :datetime
  end
end
