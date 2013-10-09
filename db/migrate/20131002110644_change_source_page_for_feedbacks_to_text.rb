class ChangeSourcePageForFeedbacksToText < ActiveRecord::Migration
  def up
    change_column :feedbacks, :source_page, :text
  end

  def down
    change_column :feedbacks, :source_page, :string
  end
end
