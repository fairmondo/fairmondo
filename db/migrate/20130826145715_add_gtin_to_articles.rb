class AddGtinToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :gtin, :string
  end
end
