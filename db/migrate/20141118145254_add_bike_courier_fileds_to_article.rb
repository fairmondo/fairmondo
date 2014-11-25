class AddBikeCourierFiledsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :transport_bike_courier, :boolean, default: false
  end
end
