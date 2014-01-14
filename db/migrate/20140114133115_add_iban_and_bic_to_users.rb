class AddIbanAndBicToUsers < ActiveRecord::Migration
  def change
    add_column :users, :iban, :string
     add_column :users, :bic, :string
  end
end
