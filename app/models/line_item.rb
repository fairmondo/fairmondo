#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LineItem < ActiveRecord::Base
  attr_accessor :business_transaction # temporary saving the data
  attr_accessor :cart_cookie # temp storage to validate with pundit

  delegate :id, to: :cart, prefix: true
  delegate :quantity, :quantity_available, :price, :title, :transport_bike_courier,
           :price_wo_vat,
           to: :article, prefix: true

  belongs_to :line_item_group, inverse_of: :line_items
  belongs_to :article, inverse_of: :line_items
  has_one :cart, through: :line_item_group, inverse_of: :line_items

  validates :requested_quantity, numericality: {
    greater_than: 0,
    less_than_or_equal_to: ->(line_item) { line_item.article_quantity_available }
  }

  #  after_rollback :set_max_requested_quantity

  def self.find_or_new params, cart_id
    joins(:cart).where('carts.id = ?', cart_id).find_by_article_id(params['article_id']) || new(params)
  end

  def prepare_line_item_group_or_assign cart, quantity
    if self.new_record?
      self.line_item_group = find_or_create_line_item_group cart
    else
      # we need to parse quantity to integer since it is a param and
      # we want to increase it for that value.
      # if quantity is nil it is probably a single quantity article
      # and we want to throw a quantity error so we increase it by 1
      # note:
      # - we need the if quantity part because to_i will be 0 for nil values
      # - we need the rescue nil part because its a param value and we need to coerce it
      quantity = quantity.to_i rescue nil if quantity
      self.requested_quantity += quantity || 1
    end
  end

  def find_or_create_line_item_group cart
    cart.line_item_group_for self.article.seller # get the seller-unique LineItemGroup (or creates one)
  end

  # after_rollback: When update failed becuase requested_quantity was too large, set it to the max available quantity
  #  def set_max_requested_quantity
  #    available = self.article_quantity_available
  #    if self.errors[:requested_quantity].any? and self.requested_quantity > available
  #      self.update_column :requested_quantity, available
  #    end
  #  end

  # Handle line_item_count on Cart
  before_create -> { Cart.increment_counter(:line_item_count, cart.id) }
  before_destroy -> { Cart.decrement_counter(:line_item_count, cart.id)  }
  after_destroy do |record|
    group = record.line_item_group
    group.destroy if group.line_items.empty?
  end

  def qualifies_for_belboon?
    line_item_group.seller.is_a?(LegalEntity) && article.is_conventional?
  end

  def orphaned?
    !self.article.present? || !self.article.valid? || !self.article.active?
  end
end
