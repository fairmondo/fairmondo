class LineItem < ActiveRecord::Base

  attr_accessor :business_transaction # tempurary saving the data

  belongs_to :line_item_group, inverse_of: :line_items
  belongs_to :article, inverse_of: :line_items
  has_one :cart, through: :line_item_group, inverse_of: :line_items

end
