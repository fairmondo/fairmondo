#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class LineItemGroupTest < ActiveSupport::TestCase
  let(:line_item_group) { create(:line_item_group) }
  let(:id) { 1 }

  subject { LineItemGroup.new }

  it 'has a valid Factory' do
    line_item_group.must_be :valid?
  end

  describe 'attributes' do
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
    it { subject.must_respond_to :purchase_id }
    it { subject.must_respond_to :sold_at }
  end

  describe '#generate_purchase_id' do
    it 'generates a valid id' do
      line_item_group.stub(:id, 1) do
        line_item_group.generate_purchase_id
        line_item_group.purchase_id.must_equal('F00000001')
      end
    end
  end
end
