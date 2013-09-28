class AddAddressSuffixTransactions < ActiveRecord::Migration
  def change
  	add_column :transactions, :address_suffix, :string
  end
end
