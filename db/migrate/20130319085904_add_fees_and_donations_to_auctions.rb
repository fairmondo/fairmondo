class AddFeesAndDonationsToAuctions < ActiveRecord::Migration
  def change
    rename_column(:auctions, :price_currency, :currency)
    add_money :auctions, :calculated_corruption, currency: { present: false }
    add_money :auctions, :calculated_friendly, currency: { present: false }
    add_money :auctions, :calculated_fee, currency: { present: false }
  end
end
