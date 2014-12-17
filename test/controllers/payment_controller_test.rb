#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'
include FastBillStubber

describe PaymentsController do
  let(:lig) { FactoryGirl.create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_type1] }
  let(:bt) { lig.business_transactions.first }
  let(:buyer) { bt.buyer }


  before do
    sign_in buyer
  end

  describe "POST 'create'" do
    describe "PaypalPayment" do
      let(:lig) { FactoryGirl.create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_type1] }

      it "should create a paypal payment and forward to show" do
        assert_difference 'Payment.count', 1 do
          post :create, line_item_group_id: lig.id, payment: { type: 'PaypalPayment' }
        end
        lig.paypal_payment.pay_key.must_be_kind_of String
        assert_redirected_to "https://www.sandbox.paypal.com/de/webscr?cmd=_ap-payment&paykey=foobar"
      end

      it "should show error on paypal api error" do
        request.env["HTTP_REFERER"] = root_path
        PaypalPayment.any_instance.stubs(:initialize_payment).returns(false)
        assert_difference 'Payment.count', 1 do
          post :create, line_item_group_id: lig.id, payment: { type: 'PaypalPayment' }
        end
        flash[:error].must_equal I18n.t('PaypalPayment.controller_error', email: lig.seller_paypal_account)
      end
    end

    describe "VoucherPayment" do
      let(:lig) { FactoryGirl.create :line_item_group, :sold, :with_business_transactions, traits: [:voucher, :transport_type1], seller: FactoryGirl.create(:seller, :paypal_data, uses_vouchers: true) }
      it "should create a voucher payment and redirect back" do
        request.env["HTTP_REFERER"] = 'http://test.host'
        assert_difference 'Payment.count', 1 do
          post :create, line_item_group_id: lig.id, payment: { type: 'VoucherPayment', pay_key: '123abc' }
        end
        assert_redirected_to :back
      end
    end
  end

  describe "GET 'show'" do
    let(:lig) { FactoryGirl.create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_bike_courier] }
    let(:payment) { FactoryGirl.create :payment, :with_pay_key, line_item_group: lig }

    it "should redirect to paypal" do
      get :show, line_item_group_id: lig.id, id: payment.id
      assert_redirected_to "https://www.sandbox.paypal.com/de/webscr?cmd=_ap-payment&paykey=foobar"
    end
  end

  describe 'GET "ipn_notification"' do
    let(:payment) { FactoryGirl.create :payment, pay_key: '1234' }

    before do
      PaypalAdaptive::IpnNotification.any_instance.stubs(:verified?).returns(true)
    end

    it 'should confirm payment when request contains "complete"' do
      payment
      post :ipn_notification, pay_key: '1234', status: 'COMPLETED'
      payment.reload.state.must_equal 'confirmed'
    end

    it 'should throw an error, when payment_status is "Invalid"' do
      payment
      post :ipn_notification, pay_key: '1234', status: 'Invalid'
      payment.reload.state.must_equal 'errored'
    end

    it 'should throw ActiveRecord::RecordNotFound if no payment is found' do
      assert_raises(ActiveRecord::RecordNotFound) { post :ipn_notification, pay_key: 'ashfakjsdf', payment_status: 'Invalid' }
    end
  end
end
