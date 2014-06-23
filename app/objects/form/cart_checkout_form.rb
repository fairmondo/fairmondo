class CartCheckoutForm
  attr_accessor :session, :cart

  def initialize session, cart
    self.session = session
    self.cart = cart
  end

  def complete?
    false
  end

  def update params

  end

end