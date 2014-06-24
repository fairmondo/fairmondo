class CartCheckoutForm
  attr_accessor :session, :cart

  def initialize session, cart
    self.session = session
    self.cart = cart
    cart.line_item_groups.map{ |l| l.valid? }
  end

  def complete?
    false
  end

  def update params

  end

  def persisted?
    false
  end
end