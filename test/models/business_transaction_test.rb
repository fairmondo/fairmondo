#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class BusinessTransactionTest < ActiveSupport::TestCase
  subject { BusinessTransaction.new }

  describe 'attributes' do
    it { subject.must_respond_to :selected_transport }
    it { subject.must_respond_to :selected_payment }
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :article_id }
    it { subject.must_respond_to :state }

    it { subject.must_respond_to :sold_at }
    it { subject.must_respond_to :purchase_emails_sent }
    it { subject.must_respond_to :discount_id }
    it { subject.must_respond_to :discount_value_cents }
    it { subject.must_respond_to :billed_for_fair }
    it { subject.must_respond_to :billed_for_fee }
    it { subject.must_respond_to :billed_for_discount }
    it { subject.must_respond_to :refunded_fee }
    it { subject.must_respond_to :refunded_fair }
  end

  describe 'associations' do
    it { subject.must belong_to :article }
    it { subject.must belong_to :line_item_group }
  end

  describe 'enumerization' do # I asked for clarification on how to do this: https://github.com/brainspec/enumerize/issues/136 - maybe comment back in when we have a positive response.
    should enumerize(:selected_transport).in(:pickup, :type1, :type2, :bike_courier)
    should enumerize(:selected_payment).in(:bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice, :voucher)
  end

  describe 'methods' do
  end
end
