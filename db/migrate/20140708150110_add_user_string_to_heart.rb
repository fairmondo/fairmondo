class AddUserStringToHeart < ActiveRecord::Migration[4.2]
  def change
    add_column :hearts, :user_token, :string
    add_index :hearts, [:user_token, :heartable_id, :heartable_type],
      unique: true
  end
end
