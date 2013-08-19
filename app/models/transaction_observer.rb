class TransactionObserver < ActiveRecord::Observer

	def after_update(transaction)
		if transaction.state == "sold"
			invoice(transaction)
		end
	end

	def invoice(transaction)
		@invoice = Invoice.new :user_id => transaction.seller.id, :invoice_date => 14.days.from_now
	end
	handle_asynchronously :invoice

end