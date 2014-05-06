class AddIndexOnStateForArticles < ActiveRecord::Migration
  def change
    add_index "articles", ["state"], :name => "index_articles_on_state"
  end
end
