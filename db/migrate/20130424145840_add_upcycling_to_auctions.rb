class AddUpcyclingToAuctions < ActiveRecord::Migration

  class Auction < ActiveRecord::Base
    attr_accessible :ecologic_kind
  end
  def up
    add_column :auctions, :ecologic_kind, :string
    add_column :auctions, :upcycling_reason, :text
    Auction.reset_column_information
    Auction.all.each do |auction|
      if auction.ecologic?
        auction.update_attributes!(:ecologic_kind => "ecologic_seal")
      end
    end
  end
  def down
    remove_column :auctions, :ecologic_kind
    remove_column :auctions, :upcycling_reason
  end
end
