class Cart < ActiveRecord::Base
  has_many :line_item_groups, dependent: :destroy, inverse_of: :cart
  has_many :line_items, through: :line_item_groups, inverse_of: :cart
  has_many :articles, through: :line_item_groups

  belongs_to :user, inverse_of: :carts

  scope :newest, -> { order(created_at: :desc) }
  scope :open, -> { where.not(sold: true) }

  attr_accessor :cookie_content # temp storage for pundit validation

  # Finds an existing cart for the logged in user or creates a new one
  # @param buyer [User, nil] logged in user or nil if user is not logged in
  # @return [Cart] found or created cart
  def self.current_or_new_for buyer
    if buyer
      current_for(buyer) || create(user: buyer)
    else
      create
    end
  end

  def self.current_for buyer
    newest.open.where(user_id: buyer.id).first
  end

  # In one cart there should only be one LIG per seller; this finds or creates it
  def line_item_group_for seller
    line_item_groups.where(seller: seller).first || LineItemGroup.create(cart: self, seller: seller)
  end

  def buy
    Article.transaction do
      locked_article_ids_with_quantities = {}
      self.line_item_groups.each do |line_item_group|
        line_item_group.line_items.each do |line_item|
          locked_article_ids_with_quantities[line_item.article.id] = line_item.requested_quantity
          line_item.business_transaction.payment.save! if line_item.business_transaction.payment
          line_item.business_transaction.save!
        end
        line_item_group.buyer_id = self.user_id
        line_item_group.save!
      end
      # sort this by article_id to prevent deadlocks
      locked_article_ids_with_quantities.sort.each do |article_id,quantity|
        article = Article.lock.find(article_id) # locks always need to refind records
        article.buy!(quantity)
      end
    end

    # This comes at a later point
    #CartMailer.buyer_email(self).deliver

    #self.line_item_groups.each do |lig|
    #  CartMailer.seller_email(lig).deliver
    #end

    return :checked_out
  rescue => e
    puts e
    debugger
    return :checkout_failed
  end
end
