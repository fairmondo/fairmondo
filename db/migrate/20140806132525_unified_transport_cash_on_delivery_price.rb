class UnifiedTransportCashOnDeliveryPrice < ActiveRecord::Migration
  def change
    add_column :users, :unified_transport_cash_on_delivery_price_cents, :integer
    add_column :line_item_groups, :unified_transport_cash_on_delivery_price_cents, :integer
  end
end
