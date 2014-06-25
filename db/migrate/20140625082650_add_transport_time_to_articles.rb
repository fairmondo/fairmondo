class AddTransportTimeToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :transport_time, :string
  end
end
