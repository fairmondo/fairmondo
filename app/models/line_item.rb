class LineItem < ActiveRecord::Base
  belongs_to :line_item_group
  belongs_to :business_transaction
end
