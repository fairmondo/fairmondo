class AddHeavyUploaderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :heavy_uploader, :boolean, default: false
  end
end
