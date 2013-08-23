class InvoiceItem < ActiveRecord::Base
	invoice_items_attributes = 	[ :article_id,
																:calculated_fair_cents,
																:calculated_fee_cents,
																:calculated_friendly_cents,
																:invoice_id,
																:price_cents,
																:quantity ]
  attr_accessible *invoice_items_attributes
  attr_accessible *invoice_items_attributes, :as => :admin

  belongs_to :article
  belongs_to :invoice
end
