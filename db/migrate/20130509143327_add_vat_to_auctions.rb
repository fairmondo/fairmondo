class AddVatToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :vat, :integer, :default => 0
  end
end
