class AddIndexOnStateForArticles < ActiveRecord::Migration[4.2]
  def change
    add_index "articles", ["state"], :name => "index_articles_on_state"
  end
end
