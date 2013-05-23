class BasicPriceAttributes < ActiveRecord::Migration

  def change
    add_money :auctions, :basic_price, currency: { present: false }
    add_column :auctions, :basic_price_amount, :string

  end

end
