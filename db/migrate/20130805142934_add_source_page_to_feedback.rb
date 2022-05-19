class AddSourcePageToFeedback < ActiveRecord::Migration[4.2]
  def change
    add_column :feedbacks, :source_page, :string
    add_column :feedbacks, :user_agent, :string
  end
end
