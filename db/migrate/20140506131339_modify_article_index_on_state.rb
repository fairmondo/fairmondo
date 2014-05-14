class ModifyArticleIndexOnState < ActiveRecord::Migration
  def change
    remove_index :articles, name: :index_articles_on_state
    add_index "articles", ["article_template_id","user_id","state"], :name => "index_articles_on_state_and_article_template_id_and_user_id"
  end
end
