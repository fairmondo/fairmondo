class AddTransportOptionsAndPaymentOptionsToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :transport, :string
    add_column :auctions, :transport_details, :text
    add_column :auctions, :payment_details, :text
  end
end
