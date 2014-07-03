class LineItem < ActiveRecord::Base

  attr_accessor :business_transaction # temporary saving the data
  attr_accessor :cart_hash # temp storage to validate with pundit

  delegate :unique_hash, to: :cart, prefix: true
  delegate :quantity, :quantity_available, to: :article, prefix: true

  belongs_to :line_item_group, inverse_of: :line_items
  belongs_to :article, inverse_of: :line_items
  has_one :cart, through: :line_item_group, inverse_of: :line_items

  validates :requested_quantity, numericality: {
    greater_than: 0,
    less_than_or_equal_to: ->(line_item) { line_item.article_quantity_available }
  }

  def self.find_or_new params
    find_by_article_id(params['article_id']) || new(params)
  end

end
