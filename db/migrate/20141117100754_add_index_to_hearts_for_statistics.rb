class AddIndexToHeartsForStatistics < ActiveRecord::Migration
  def change
    add_index "hearts", ["heartable_id", "heartable_type", "updated_at"], name: "index_hearts_for_popularity_worker"
  end
end
