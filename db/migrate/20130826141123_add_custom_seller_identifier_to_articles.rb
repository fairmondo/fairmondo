class AddCustomSellerIdentifierToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :custom_seller_identifier, :string
  end
end
