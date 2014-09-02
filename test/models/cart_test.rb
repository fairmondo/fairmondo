require "test_helper"

describe Cart do
  let(:cart) { Cart.new }

  it "must be valid" do
    cart.must_be :valid?
  end

  describe '#generate_purchase_id_for' do
    it 'generates a valid id' do
      Cart.generate_purchase_id_for(23).must_equal('F00000023')
    end
  end
end
