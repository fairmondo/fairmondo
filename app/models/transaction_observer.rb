class TransactionObserver < ActiveRecord::Observer


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