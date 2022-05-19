class AddIbanAndBicToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :iban, :string
     add_column :users, :bic, :string
  end
end
