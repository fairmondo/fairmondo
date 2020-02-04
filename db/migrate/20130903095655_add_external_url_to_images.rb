class AddExternalUrlToImages < ActiveRecord::Migration[4.2]
  def change
    add_column :images, :external_url, :string
  end
end
