class AddPaymentToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :payment, :string
  end
end
