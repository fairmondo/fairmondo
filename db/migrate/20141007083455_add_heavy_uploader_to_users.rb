class AddHeavyUploaderToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :heavy_uploader, :boolean, default: false
  end
end
