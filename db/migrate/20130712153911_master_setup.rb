class MasterSetup < ActiveRecord::Migration[4.2]
  def up
    # Change Transaction Table
    add_column :transactions, :selected_transport, :string
    add_column :transactions, :selected_payment, :string
    add_column :transactions, :tos_accepted, :boolean, default: false
    remove_column :transactions, :max_bid
    # Add Buyer To Transaction
    add_column :transactions, :buyer_id, :integer
    # Add State To Transaction
    add_column :transactions, :state, :string
    add_index :transactions, :buyer_id
  end

  def down
    # Change Transaction Table
    remove_column :transactions, :selected_transport
    remove_column :transactions, :selected_payment
    remove_column :transactions, :tos_accepted
    add_column :transactions, :max_bid, :integer
    # Add Buyer To Transaction
    remove_column :transactions, :buyer_id
    # Add State To Transaction
    remove_column :transactions, :state
    remove_index :transactions, :buyer_id
  end
end
