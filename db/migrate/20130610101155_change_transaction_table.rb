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
