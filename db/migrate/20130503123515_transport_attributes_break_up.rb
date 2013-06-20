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
class TransportAttributesBreakUp < ActiveRecord::Migration
  class Auction < ActiveRecord::Base

  end

  def up
     # Broke up array relation to be more flexible
     add_column :auctions, :transport_pickup, :boolean
     add_column :auctions, :transport_insured, :boolean
     add_column :auctions, :transport_uninsured, :boolean

     #Details on real transport methods
     add_column :auctions, :transport_insured_provider, :string
     add_column :auctions, :transport_uninsured_provider, :string
     add_money  :auctions, :transport_insured_price , currency: { present: false }
     add_money  :auctions, :transport_uninsured_price , currency: { present: false }

     Auction.reset_column_information

     #get old auctions in shape for dev server
     Auction.all.each do |auction|
       auction.transport = "pickup"
       auction.transport_pickup = true
       auction.save
     end
  end

  def down
     raise ActiveRecord::IrreversibleMigration
  end
end
