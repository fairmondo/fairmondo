class AddAddressSuffixToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :address_suffix, :string
  end
end
