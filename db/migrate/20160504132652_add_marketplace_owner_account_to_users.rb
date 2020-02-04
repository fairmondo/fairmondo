class AddMarketplaceOwnerAccountToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :marketplace_owner_account, :boolean, default: false
  end
end
