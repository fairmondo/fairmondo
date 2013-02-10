class AddAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :title, :string
    add_column :users, :country, :string
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :zip, :string
    add_column :users, :phone, :string
    add_column :users, :mobile, :string
    add_column :users, :fax, :string
  end
end
