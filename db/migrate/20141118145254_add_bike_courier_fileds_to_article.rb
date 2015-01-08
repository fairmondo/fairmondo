class AddBikeCourierFiledsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :transport_bike_courier, :boolean, default: false
    add_column :articles, :transport_bike_courier_number, :integer, default: 1
  end
end
