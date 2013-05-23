class ChangePaymentDetails < ActiveRecord::Migration

  class Auction < ActiveRecord::Base

  end

  def up

     # Make payments flat
     # Code a little cluttered but easy to handle in auction form

     add_column :auctions, :payment_bank_transfer, :boolean
     add_column :auctions, :payment_cash, :boolean
     add_column :auctions, :payment_paypal, :boolean
     add_column :auctions, :payment_cash_on_delivery, :boolean
     add_column :auctions, :payment_invoice, :boolean

     add_money  :auctions, :payment_cash_on_delivery_price , currency: { present: false }
     rename_column :auctions, :payment , :default_payment

     add_column :users,    :bank_code, :string
     add_column :users,    :bank_name, :string
     add_column :users,    :bank_account_owner, :string
     add_column :users,    :bank_account_number, :string
     add_column :users,    :paypal_account, :string

     Auction.reset_column_information

     #get old auctions in shape for dev server
     Auction.all.each do |auction|
       auction.default_payment = "cash"
       auction.payment_cash = true
       auction.save
     end

  end

  def down
     remove_column :auctions, :payment_bank_transfer
     remove_column :auctions, :payment_cash
     remove_column :auctions, :payment_paypal
     remove_column :auctions, :payment_cash_on_delivery
     remove_column :auctions, :payment_invoice
     remove_column :users, :bank_code
     remove_column :users, :bank_name
     remove_column :users, :bank_account_owner
     remove_column :users, :bank_account_number
     remove_column :users, :paypal_account
     remove_column :auctions, :payment_cash_on_delivery_price_cents
     rename_column :auctions, :default_payment , :payment

     Auction.reset_column_information

     #get old auctions in shape for dev server
     Auction.all.each do |auction|
       auction.payment = "[cash]"
       auction.save
     end
  end
end
