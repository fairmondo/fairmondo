class UnifiedTransportMethod < ActiveRecord::Migration
  def change
    add_column :users, :unified_transport_maximum_articles, :integer, default: 1
    add_column :users, :unified_transport_provider, :string
    add_column :users, :unified_transport_price_cents, :integer, limit: 8, default: 0
    add_column :users, :unified_transport_free, :boolean
    add_column :users, :unified_transport_free_at_price_cents, :integer, limit: 8, default: 0

    add_column :business_transactions, :unified_transport_provider, :string
    add_column :business_transactions, :unified_transport_maximum_articles, :integer
    add_column :business_transactions, :unified_transport_price_cents, :integer, limit: 8, default: 0
    add_column :business_transactions, :unified_transport_free_at_price_cents, :integer, limit: 8, default: 0

    add_column :articles, :unified_transport, :boolean
  end
end
