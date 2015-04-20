class CleanDbFromUnusedAttributes < ActiveRecord::Migration
  def change
    remove_column :users, :forename
    remove_column :users, :surname
    remove_column :users, :title
    remove_column :users, :street
    remove_column :users, :country
    remove_column :users, :zip
    remove_column :users, :company_name
    remove_column :users, :address_suffix
    remove_column :users, :trustcommunity
    remove_column :users, :invitor_id
    remove_column :business_transactions, :forename
    remove_column :business_transactions, :surname
    remove_column :business_transactions, :street
    remove_column :business_transactions, :country
    remove_column :business_transactions, :zip
    remove_column :business_transactions, :address_suffix
  end
end
