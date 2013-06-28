class AddTypeSubjectToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :feedback_subject, :string
    add_column :feedbacks, :help_subject, :string
  end
end
