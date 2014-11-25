class AddTransportTimeToLineItemGroup < ActiveRecord::Migration
  def change
    add_column :line_item_groups, :transport_time, :datetime, default: nil
  end
end
