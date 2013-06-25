class AddUserAndArticleToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :user_id, :integer
    add_column :feedbacks, :article_id, :integer
  end
end
