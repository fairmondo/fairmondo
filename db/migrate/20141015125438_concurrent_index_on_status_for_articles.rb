class ConcurrentIndexOnStatusForArticles < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_index :articles, :state, algorithm: :concurrently
  end
end
