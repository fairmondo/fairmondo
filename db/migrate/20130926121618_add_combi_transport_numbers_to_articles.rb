class AddCombiTransportNumbersToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :transport_type1_number, :integer
    add_column :articles, :transport_type2_number, :integer
  end
end
