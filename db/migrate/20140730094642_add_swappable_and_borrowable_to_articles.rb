class AddSwappableAndBorrowableToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :swappable, :boolean, default: false
    add_column :articles, :borrowable, :boolean, default: false
  end
end
