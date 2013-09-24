module InvoicesHelper
	def invoice_chain
	end

	def has_open_invoice( seller )
		# if seller
		# end
		false
	end

	def create_new_invoice( article, seller )
		invoice = Invoice.new  :user_id => article.user_id,
                           :article_id => article.id,
                           :invoice_date => Time.now,
                           :due_date => 1.month.from_now
    invoice.save
	end

	def add_article_to_invoice( article )
	end

	def has_paid_quarterly_fee?
	end
end