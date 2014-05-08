class AddIndexOnCreatedAtOnArticles < ActiveRecord::Migration
  def change
    remove_index :articles, name: "index_articles_on_state_and_article_template_id_and_user_id"
    add_index "articles", ["created_at"], :name => "index_articles_on_created_at"
  end
end
