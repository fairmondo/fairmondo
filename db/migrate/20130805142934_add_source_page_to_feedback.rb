class AddSourcePageToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :source_page, :string
    add_column :feedbacks, :user_agent, :string
  end
end
