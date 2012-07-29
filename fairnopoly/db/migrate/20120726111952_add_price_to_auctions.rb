class AddPriceToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :price_cents, :integer

    add_column :auctions, :price_currency, :string

  end
end
