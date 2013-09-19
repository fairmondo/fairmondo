class AddCustomSellerIdentifierToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :custom_seller_identifier, :string
  end
end
