class AddMarketplaceOwnerAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :marketplace_owner_account, :boolean, default: false
  end
end
