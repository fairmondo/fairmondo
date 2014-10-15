class ConcurrentIndexOnStatusForArticles < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_index :articles, :status, algorithm: :concurrently
  end
end
