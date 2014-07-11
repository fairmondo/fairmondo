class AddHearts < ActiveRecord::Migration
  def change
    create_table :hearts do |t|
      t.references :user, index: true
      t.references :heartable, index: true, polymorphic: true

      t.timestamps
    end

    add_index :hearts, [:user_id, :heartable_id, :heartable_type], unique: true
  end
end
