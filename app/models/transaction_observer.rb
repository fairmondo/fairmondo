class TransactionObserver < ActiveRecord::Observer
	def after_buy( transaction, transition )
		Invoice.invoice_action_chain( transaction )
	end
end