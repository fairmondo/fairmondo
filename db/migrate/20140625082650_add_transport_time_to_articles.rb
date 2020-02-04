class AddTransportTimeToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :transport_time, :string
  end
end
