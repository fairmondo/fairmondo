require "test_helper"

describe Cart do
  let(:cart) { Cart.new }

  it "must be valid" do
    cart.must_be :valid?
  end


end
