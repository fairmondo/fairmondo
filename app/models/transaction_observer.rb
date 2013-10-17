# See http://rails-bestpractices.com/posts/19-use-observer
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

class TransactionObserver < ActiveRecord::Observer
  # def after_buy transaction, transition
  #   unless transaction.multiple?
  #     # Start the invoice action chain, to create invoices and add items to invoice
  #     Invoice.invoice_action_chain( transaction )
  #   end
  # end

  def after_update transaction
    # kann auch zu after-buy gemacht werden (eventuell)
    if transaction.sold? && !transaction.multiple? && !transaction.purchase_emails_sent
      # Send an email to the seller
      TransactionMailer.seller_notification(transaction).deliver

      # Send a confirmation email to the buyer
      TransactionMailer.buyer_notification(transaction).deliver

      transaction.update_attribute :purchase_emails_sent, true
    end
  end
end
