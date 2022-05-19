class ConvertCommentTextToText < ActiveRecord::Migration[4.2]
  def change
    change_column :comments, :text, :text
  end
end
