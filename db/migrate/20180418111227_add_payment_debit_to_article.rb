class AddPaymentDebitToArticle < ActiveRecord::Migration[4.2]
  def change
      add_column :articles, :payment_debit, :boolean, :default => false
  end
end
