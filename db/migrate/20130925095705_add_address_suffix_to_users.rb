class AddAddressSuffixToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address_suffix, :string
  end
end
