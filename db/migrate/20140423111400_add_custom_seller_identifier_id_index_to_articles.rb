class AddCustomSellerIdentifierIdIndexToArticles < ActiveRecord::Migration
  def change
    add_index :articles, [:custom_seller_identifier, :user_id]
  end
end
