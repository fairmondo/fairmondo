#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class Transaction < ActiveRecord::Base
  extend Enumerize

  has_one :article
  attr_accessible :type, :selected_transport, :selected_payment, :tos_accepted

  #@todo remove duplication with data in Article::Attributes
  enumerize :selected_transport, in: [:pickup, :insured, :uninsured]
  enumerize :selected_payment, in: [:bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice]

  delegate :title, :seller, to: :article, prefix: true

  # def possible_transports

  # end
  # def possible_payments

  # end
end
