class TransportAttributesBreakUp < ActiveRecord::Migration
  class Auction < ActiveRecord::Base
    
  end
  
  def up
     # Broke up array relation to be more flexible
     add_column :auctions, :transport_pickup, :boolean
     add_column :auctions, :transport_insured, :boolean
     add_column :auctions, :transport_uninsured, :boolean
     
     #Details on real transport methods
     add_column :auctions, :transport_insured_provider, :string
     add_column :auctions, :transport_uninsured_provider, :string
     add_money  :auctions, :transport_insured_price , currency: { present: false }
     add_money  :auctions, :transport_uninsured_price , currency: { present: false }
     
     Auction.reset_column_information
     
     #get old auctions in shape for dev server
     Auction.all.each do |auction|
       auction.transport = "pickup"
       auction.transport_pickup = true
       auction.save
     end
  end

  def down
     raise ActiveRecord::IrreversibleMigration
  end
end
