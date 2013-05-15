class RenameAuctionsToArticles < ActiveRecord::Migration
  def change
    rename_table :auctions, :articles
    rename_table :auction_templates, :article_templates
    rename_table :auctions_categories, :articles_categories
  end
end
