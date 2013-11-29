class AddDiscountIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :discount_id, :integer
  end
end
