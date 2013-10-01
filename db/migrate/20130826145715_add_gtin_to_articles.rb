class AddGtinToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :gtin, :string
  end
end
