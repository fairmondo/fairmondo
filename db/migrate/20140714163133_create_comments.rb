class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :commentable, index: true, polymorphic: true

      t.string :text

      t.timestamps
    end
  end
end
