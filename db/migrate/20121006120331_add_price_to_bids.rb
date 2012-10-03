class AddPriceToBids < ActiveRecord::Migration
  def change
    add_column :bids, :price_cents, :integer

    add_column :bids, :price_currency, :string

  end
end
