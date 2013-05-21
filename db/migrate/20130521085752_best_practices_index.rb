class BestPracticesIndex < ActiveRecord::Migration
  def change
     add_index :articles, :article_template_id
     add_index :article_templates, :user_id
     add_index :articles, :user_id
     add_index :articles, :transaction_id
     add_index :bids, :user_id
     add_index :categories, :parent_id
     add_index :fair_trust_questionnaires, :article_id
     add_index :libraries, :user_id
     add_index :library_elements, :library_id
     add_index :library_elements, :article_id
     add_index :social_producer_questionnaires, :article_id
  end
end
