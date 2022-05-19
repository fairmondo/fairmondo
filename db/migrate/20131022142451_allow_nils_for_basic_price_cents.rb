class AllowNilsForBasicPriceCents < ActiveRecord::Migration[4.2]
  def up
    change_column :articles, :basic_price_cents, :integer, :default => 0, :null => true
  end

  def down
    change_column :articles, :basic_price_cents, :integer, :default => 0, :null => false
  end
end
