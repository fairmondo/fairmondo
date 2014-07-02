class ChangeLineItemId < ActiveRecord::Migration
  def change
    rename_column :line_items, :business_transaction_id, :article_id
  end
end
