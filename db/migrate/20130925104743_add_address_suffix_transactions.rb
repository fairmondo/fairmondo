class AddAddressSuffixTransactions < ActiveRecord::Migration[4.2]
  def change
  	add_column :transactions, :address_suffix, :string
  end
end
