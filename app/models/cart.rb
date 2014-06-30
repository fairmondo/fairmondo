class Cart < ActiveRecord::Base
  has_many :line_item_groups, dependent: :destroy, inverse_of: :cart
  has_many :line_items, through: :line_item_groups, inverse_of: :cart
  belongs_to :user, inverse_of: :carts

  before_create :generate_unique_hash

  scope :newest , -> { order(created_at: :desc) }
  scope :open , -> { where.not(sold: true) }

  # Finds an existing cart for the logged in user or creates a new one
  # @param buyer [User, nil] logged in user or nil if user is not logged in
  # @return [Cart] found or created cart
  def self.current_or_new_for buyer
    if buyer
      newest.open.where(user_id: buyer.id).first || create(user: buyer)
    else
      create
    end
  end

  # In one cart there should only be one LIG per seller; this finds or creates it
  def line_item_group_for seller
    line_item_groups.where(seller: seller).first || LineItemGroup.create(cart: self, seller: seller)
  end

  private
    def generate_unique_hash
      self.unique_hash = Digest::SHA1.hexdigest([Time.now, rand].join)
    end
end
