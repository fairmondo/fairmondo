require_relative '../test_helper'

describe LineItemGroup do
  let(:line_item_group) { FactoryGirl.create(:line_item_group) }

  subject { LineItemGroup.new }

  it "has a valid Factory" do
    line_item_group.must_be :valid?
  end

  describe "attributes" do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :seller_id }
    it { subject.must_respond_to :buyer_id }
    it { subject.must_respond_to :cart_id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :unified_transport }
    it { subject.must_respond_to :unified_payment }
    it { subject.must_respond_to :unified_payment_method }
    it { subject.must_respond_to :tos_accepted }
    it { subject.must_respond_to :message }
    it { subject.must_respond_to :transport_address_id }
    it { subject.must_respond_to :payment_address_id }
  end

end
