class AddPaymentDebitToArticle < ActiveRecord::Migration
  def change
      add_column :articles, :payment_debit, :boolean, :default => false
  end
end
