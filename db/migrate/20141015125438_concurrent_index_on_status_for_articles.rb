class ConcurrentIndexOnStatusForArticles < ActiveRecord::Migration[4.2]
  disable_ddl_transaction!
  def change
    add_index :articles, :state, algorithm: :concurrently
  end
end
