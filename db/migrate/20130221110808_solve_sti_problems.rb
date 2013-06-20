#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class SolveStiProblems < ActiveRecord::Migration
  class Transaction < ActiveRecord::Base
  end
  class Auction < ActiveRecord::Base
    attr_accessible :transaction_id
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
