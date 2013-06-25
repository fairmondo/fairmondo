class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :text
      t.string :subject
      t.string :from
      t.string :to

      t.string :type

      t.timestamps
    end
  end
end
