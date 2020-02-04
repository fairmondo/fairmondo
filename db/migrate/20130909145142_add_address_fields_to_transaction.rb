class AddAddressFieldsToTransaction < ActiveRecord::Migration[4.2]
  def change
  	add_column :transactions, :forename, :string
  	add_column :transactions, :surname, :string
    add_column :transactions, :street, :string
    add_column :transactions, :city, :string
    add_column :transactions, :zip, :string
    add_column :transactions, :country, :string
  end
end
