class AddQuantityFieldsToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column :transactions, :quantity_available, :integer, default: nil
    add_column :transactions, :quantity_bought, :integer, default: nil

    add_column :articles, :quantity_sold, :integer, default: 0
  end
end
