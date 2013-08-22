class TransactionObserver < ActiveRecrd::Observer
	def after_update(transaction)
		puts "Hallo, ich wurde geupdatet!"
	end
end