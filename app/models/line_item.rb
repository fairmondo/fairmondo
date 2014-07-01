class LineItem < ActiveRecord::Base
  belongs_to :line_item_group, inverse_of: :line_items
  belongs_to :business_transaction, inverse_of: :line_items
  has_one :article, through: :business_transaction, inverse_of: :line_items
  has_one :cart, through: :line_item_group, inverse_of: :line_items

  attr_accessor :cart_hash # temp storage to validate with pundit

  delegate :unique_hash, to: :cart, prefix: true

  def self.find_or_new params
    find_by_business_transaction_id(params['business_transaction_id']) || new(params)
  end
end
