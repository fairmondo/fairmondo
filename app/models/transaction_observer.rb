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
  # def after_update transaction
  #   # Send an email to the seller
  #   TransactionMailer.seller_notification(transaction).deliver

  #   # Send a confirmation email to the buyer
  #   TransactionMailer.buyer_notification(transaction).deliver
  # end


	# Don't know if this works...
	def after_buy(transaction)
		invoice(transaction)
	end

	def invoice(transaction)
		@article = Article.find_by_transaction_id(transaction.id)

		# if user has invoice do
		# 	add transaction_article to Invoice
		# else
		# 	create new invoice with transaction_article
		# end

		@invoice = Invoice.new 	:user_id => @article.user_id,
														:due_date => 14.days.from_now
		@invoice.save
	end
	handle_asynchronously :invoice

end