class AddCombiTransportNumbersToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :transport_type1_number, :integer, default: 1
    add_column :articles, :transport_type2_number, :integer, default: 1
  end
end
