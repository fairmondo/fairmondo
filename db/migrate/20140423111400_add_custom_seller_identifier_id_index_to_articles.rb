class AddCustomSellerIdentifierIdIndexToArticles < ActiveRecord::Migration[4.2]
  def change
    add_index :articles, [:custom_seller_identifier, :user_id]
  end
end
