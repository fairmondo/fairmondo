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
class AddUpcyclingToAuctions < ActiveRecord::Migration

  class Auction < ActiveRecord::Base
    attr_accessible :ecologic_kind
  end
  def up
    add_column :auctions, :ecologic_kind, :string
    add_column :auctions, :upcycling_reason, :text
    Auction.reset_column_information
    Auction.all.each do |auction|
      if auction.ecologic?
        auction.update_attributes!(:ecologic_kind => "ecologic_seal")
      end
    end
  end
  def down
    remove_column :auctions, :ecologic_kind
    remove_column :auctions, :upcycling_reason
  end
end
