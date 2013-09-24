class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.integer :article_id
      t.integer :price_cents
      t.integer :calculated_fee_cents
      t.integer :calculated_fair_cents
      t.integer :calculated_friendly_cents
      t.integer :quantity

      t.timestamps
    end
  end
end
