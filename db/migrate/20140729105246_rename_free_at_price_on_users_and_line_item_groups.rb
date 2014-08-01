class RenameFreeAtPriceOnUsersAndLineItemGroups < ActiveRecord::Migration
  def change
    rename_column :users, :unified_transport_free, :free_transport_available
    rename_column :users, :unified_transport_free_at_price_cents, :free_transport_at_price_cents
    rename_column :line_item_groups, :unified_transport_free_at_price_cents, :free_transport_at_price_cents
  end
end
