class AddExternalUrlToImages < ActiveRecord::Migration
  def change
    add_column :images, :external_url, :string
  end
end
