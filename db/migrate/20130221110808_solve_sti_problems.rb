class SolveStiProblems < ActiveRecord::Migration
  class Transaction < ActiveRecord::Base
  end
  class Auction < ActiveRecord::Base
  end
  def up
    add_column :auctions, :transaction_id, :integer
   
    Auction.reset_column_information
    Transaction.reset_column_information
    Auction.all.each do |auction|
      transaction = Transaction.where(:auction_id => auction.id).first
      auction.update_attributes! :transaction_id => transaction.id unless transaction == nil 
    end
    remove_column :transactions, :auction_id
  end

  def down
    add_column :transactions, :auction_id, :integer
    Auction.reset_column_information
    Transaction.reset_column_information
    Transaction.all.each do |transaction|
      auction = Auction.where(:transaction_id => transaction.id).first
      transaction.update_attributes! :auction_id => auction.id unless auction == nil
    end
    remove_column :auctions, :transaction_id
    
  end
end
