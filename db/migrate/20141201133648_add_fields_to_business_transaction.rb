class AddFieldsToBusinessTransaction < ActiveRecord::Migration[4.2]
  def change
    add_column :business_transactions, :tos_bike_courier_accepted, :boolean, default: false
    add_column :business_transactions, :bike_courier_message, :text, default: nil
    add_column :business_transactions, :bike_courier_time, :string, default: nil
  end
end
