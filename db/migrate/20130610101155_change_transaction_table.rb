class ChangeTransactionTable < ActiveRecord::Migration
  def up
    add_column :transactions, :selected_transport, :string
    add_column :transactions, :selected_payment, :string
    add_column :transactions, :tos_accepted, :boolean, default: false
    remove_column :transactions, :max_bid
  end

  def down
    remove_column :transactions, :selected_transport
    remove_column :transactions, :selected_payment
    remove_column :transactions, :tos_accepted
    add_column :transactions, :max_bid, :integer
  end
end
