class AddIndexToCommentsForStatistics < ActiveRecord::Migration[4.2]
  def change
    add_index "comments", ["commentable_id", "commentable_type", "updated_at"], name: "index_comments_for_popularity_worker"
  end
end
