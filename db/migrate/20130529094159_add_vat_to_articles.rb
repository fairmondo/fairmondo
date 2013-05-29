class AddVatToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :vat, :integer, :default => 0
  end
end
