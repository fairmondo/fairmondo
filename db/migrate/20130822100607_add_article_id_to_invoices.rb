class AddArticleIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :article_id, :integer
  end
end
