class MoveUnifiedTransportColumns < ActiveRecord::Migration
  def change
    remove_column :business_transactions, :unified_transport_provider
    remove_column :business_transactions, :unified_transport_maximum_articles
    remove_column :business_transactions, :unified_transport_price_cents
    remove_column :business_transactions, :unified_transport_free_at_price_cents
    add_column :line_item_groups, :unified_transport_provider, :string
    add_column :line_item_groups, :unified_transport_maximum_articles, :integer
    add_column :line_item_groups, :unified_transport_price_cents, :integer,         limit: 8, default: 0
    add_column :line_item_groups, :unified_transport_free_at_price_cents, :integer, limit: 8
  end
end
