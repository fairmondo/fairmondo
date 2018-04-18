class AddSubscriptionToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :subscription, :boolean, :default => false
  end
end
