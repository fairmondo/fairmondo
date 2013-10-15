class RemoveArticleIdFromInvoices < ActiveRecord::Migration
  def up
    remove_column :invoices, :article_id
  end

  def down
    add_column :invoices, :article_id, :integer
  end
end
