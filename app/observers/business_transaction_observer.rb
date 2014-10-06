# See http://rails-bestpractices.com/posts/19-use-observer
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#

class BusinessTransactionObserver < ActiveRecord::Observer

  def before_create business_transaction
    business_transaction.sold_at = Time.now
  end

  def after_create business_transaction

    #if !business_transaction.purchase_emails_sent
      # Send an email to the seller
      #BusinessTransactionMailerWorker.perform_in 5.seconds, business_transaction.id, :seller

      # Send a confirmation email to the buyer
      #BusinessTransactionMailerWorker.perform_in 5.seconds, business_transaction.id, :buyer

      #business_transaction.update_attribute :purchase_emails_sent, true
    #end

  end
end
