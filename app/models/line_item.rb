class LineItem < ActiveRecord::Base

  attr_accessor :business_transaction # temporary saving the data
  attr_accessor :cart_cookie # temp storage to validate with pundit

  delegate :id, to: :cart, prefix: true
  delegate :quantity, :quantity_available, to: :article, prefix: true

  belongs_to :line_item_group, inverse_of: :line_items
  belongs_to :article, inverse_of: :line_items
  has_one :cart, through: :line_item_group, inverse_of: :line_items

  validates :requested_quantity, numericality: {
    greater_than: 0,
    less_than_or_equal_to: ->(line_item) { line_item.article_quantity_available }
  }

  after_rollback :set_max_requested_quantity

  def self.find_or_new params, cart_id
    joins(:cart).where("carts.id = ?", cart_id).find_by_article_id(params['article_id']) || new(params)
  end

  # after_rollback: When update failed becuase requested_quantity was too large, set it to the max available quantity
  def set_max_requested_quantity
    available = self.article_quantity_available
    if self.errors[:requested_quantity].any? and self.requested_quantity > available
      self.update_column :requested_quantity, available
    end
  end

  # Handle line_item_count on Cart
  before_create  -> { Cart.increment_counter(:line_item_count, cart.id) }
  before_destroy -> { Cart.decrement_counter(:line_item_count, cart.id) }
end
