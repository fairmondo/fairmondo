class TransactionInvoiceController < InheritedResources::Base
	respond_to :html
	actions :show

	before_filter :authorize_resource

	def show

	end
end