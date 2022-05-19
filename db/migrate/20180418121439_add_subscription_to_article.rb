class AddSubscriptionToArticle < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :subscription, :boolean, :default => false
  end
end
