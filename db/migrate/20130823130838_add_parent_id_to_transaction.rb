class AddParentIdToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :parent_id, :integer, default: nil
    add_index "transactions", ["parent_id"], :name => "index_transactions_on_parent_id"
  end
end
