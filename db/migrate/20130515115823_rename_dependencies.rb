class RenameDependencies < ActiveRecord::Migration
  def change
    rename_column :articles, :auction_template_id, :article_template_id
    rename_column :articles_categories, :auction_id, :article_id
    rename_column :fair_trust_questionnaires, :auction_id, :article_id
    rename_column :images, :auction_id, :article_id
    rename_column :library_elements, :auction_id, :article_id
    rename_column :social_producer_questionnaires, :auction_id, :article_id
    rename_index :articles, 'index_auctions_on_auction_template_id', 'index_articles_on_article_template_id'
    rename_index :articles, 'index_auctions_on_id_and_auction_template_id','index_articles_on_id_and_article_template_id'
    rename_index :articles, 'index_auctions_on_slug', 'index_articles_on_slug'
    rename_index :articles_categories, 'index_auctions_categories_on_auction_id_and_category_id' , 'index_articles_categories_on_article_id_and_category_id'
    rename_index :articles_categories, 'index_auctions_categories_on_auction_id', 'index_articles_categories_on_article_id'
    rename_index :articles_categories, 'index_auctions_categories_on_category_id', 'index_articles_categories_on_category_id'
  end
  
  


  
end
