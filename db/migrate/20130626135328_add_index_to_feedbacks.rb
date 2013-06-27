class AddIndexToFeedbacks < ActiveRecord::Migration
  def change
    add_index :feedbacks, :user_id
    add_index :feedbacks, :article_id
  end
end
