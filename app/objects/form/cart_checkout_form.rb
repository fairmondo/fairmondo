class CartCheckoutForm
  include ActiveModel::Model
  attr_accessor :session, :cart

  def initialize session, cart
    self.session = session
    self.cart = cart
    fill_data session, cart
  end

  def complete?
    false
  end

  def process params
    fill_data params, cart
  end

  def fill_data hash, cart
    # unified transport and payment
    if hash[:line_item_groups]
      hash[:line_item_groups].each do |id, params|
        line_item_group = @cart.line_item_groups.find id
        line_item_group.assign_attributes( ActionController::Parameters.new(params).for(LineItemGroup).on(:update) )
      end
    end
  end

end