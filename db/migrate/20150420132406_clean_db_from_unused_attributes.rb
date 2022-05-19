class CleanDbFromUnusedAttributes < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :forename
    remove_column :users, :surname
    remove_column :users, :title
    remove_column :users, :street
    remove_column :users, :country
    remove_column :users, :zip
    remove_column :users, :city
    remove_column :users, :company_name
    remove_column :users, :address_suffix
    remove_column :users, :trustcommunity
    remove_column :users, :invitor_id

    remove_column :business_transactions, :forename
    remove_column :business_transactions, :surname
    remove_column :business_transactions, :street
    remove_column :business_transactions, :country
    remove_column :business_transactions, :zip
    remove_column :business_transactions, :city
    remove_column :business_transactions, :address_suffix
    remove_column :business_transactions, :type_fix
    remove_column :business_transactions, :expire rescue
    remove_column :business_transactions, :message
    remove_column :business_transactions, :buyer_id
    remove_column :business_transactions, :seller_id
    remove_column :business_transactions, :quantity_available
    remove_column :business_transactions, :tos_accepted

    remove_column :ratings, :business_transaction_id
  end
end
