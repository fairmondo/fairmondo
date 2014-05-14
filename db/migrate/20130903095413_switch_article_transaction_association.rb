class SwitchArticleTransactionAssociation < ActiveRecord::Migration

  class Transaction < ActiveRecord::Base
  end

  def up
    add_column :transactions, :article_id, :integer
    add_index "transactions", ["article_id"], :name => "index_transactions_on_article_id"

    Transaction.after_update.clear
    Transaction.unscoped.all.each do |t|
      begin
        t.update_attribute :article_id, Article.find_by_transaction_id(t.id).id
        puts "Transaction #{t.id} migrated."
      rescue
        puts "Error migrating Transaction #{t.id}: #{$!}"
      end
    end

    remove_column :articles, :transaction_id
  end

  def down
    add_column :articles, :transaction_id, :integer
    add_index "articles", ["transaction_id"], :name => "index_articles_on_transaction_id"

    Article.unscoped.all.each do |a|
      begin
        a.update_attribute :transaction_id, Transaction.find_by_article_id(a.id).id
        puts "Article #{a.id} rolled back."
      rescue
        puts "Error rolling back Article #{a.id}: #{$!}"
      end
    end

    remove_column :transactions, :article_id
  end
end
