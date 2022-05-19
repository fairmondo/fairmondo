#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  let(:lig) { create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_type1] }
  let(:bt) { lig.business_transactions.first }
  let(:buyer) { bt.buyer }

  before do
    sign_in buyer
  end

  describe "POST 'create'" do
    describe 'PaypalPayment' do
      let(:lig) { create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_type1] }

      it 'should create a paypal payment and forward to show' do
        assert_difference 'Payment.count', 1 do
          post :create, params: { line_item_group_id: lig.id, payment: { type: 'PaypalPayment' } }
        end
        lig.paypal_payment.pay_key.must_be_kind_of String
        assert_redirected_to 'https://www.sandbox.paypal.com/de/webscr?cmd=_ap-payment&paykey=foobar'
      end

      it 'should show error on paypal api error' do
        request.env['HTTP_REFERER'] = root_path
        PaypalPayment.any_instance.stubs(:initialize_payment).returns(false)
        assert_difference 'Payment.count', 1 do
          post :create, params: { line_item_group_id: lig.id, payment: { type: 'PaypalPayment' } }
        end
        flash[:error].must_equal I18n.t('PaypalPayment.controller_error', email: lig.seller_paypal_account)
      end
    end

    describe 'VoucherPayment' do
      let(:lig) { create :line_item_group, :sold, :with_business_transactions, traits: [:voucher, :transport_type1], seller: create(:seller, :paypal_data, uses_vouchers: true) }
      it 'should create a voucher payment and redirect back' do
        request.env['HTTP_REFERER'] = 'http://test.host'
        assert_difference 'Payment.count', 1 do
          post :create, params: { line_item_group_id: lig.id, payment: { type: 'VoucherPayment', pay_key: '123abc' } }
        end
        assert_redirected_to 'http://test.host'
      end
    end
  end

  describe "GET 'show'" do
    let(:lig) { create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_bike_courier] }
    let(:payment) { create :paypal_payment_with_pay_key, line_item_group: lig }

    it 'should redirect to paypal' do
      get :show, params: { line_item_group_id: lig.id, id: payment.id }
      assert_redirected_to 'https://www.sandbox.paypal.com/de/webscr?cmd=_ap-payment&paykey=foobar'
    end
  end

  describe 'GET "ipn_notification"' do
    let(:payment) { create :paypal_payment, pay_key: '1234' }

    before do
      PaypalAdaptive::IpnNotification.any_instance.stubs(:verified?).returns(true)
    end

    it 'should confirm payment when request contains "complete"' do
      payment
      post :ipn_notification, params: { pay_key: '1234', status: 'COMPLETED' }
      payment.reload.state.must_equal 'confirmed'
    end

    # TODO find out why this test passes and coverall thinks corresponding line is not touched
    it "should send email for each business transaction in payment's line item group if  bike_courier is selected" do
      business_transaction = payment.line_item_group.business_transactions.select { |bt| bt.selected_payment == 'paypal' }.first
      business_transaction.update_attribute(:selected_transport, :bike_courier)
      mail_mock = mock()
      mail_mock.expects(:deliver_later)
      CartMailer.expects(:courier_notification).with(business_transaction).returns(mail_mock)
      post :ipn_notification, params: { pay_key: '1234', status: 'COMPLETED' }
    end

    it 'should throw an error, when payment_status is "Invalid"' do
      payment
      post :ipn_notification, params: { pay_key: '1234', status: 'Invalid' }
      payment.reload.state.must_equal 'errored'
    end

    it 'should throw ActiveRecord::RecordNotFound if no payment is found' do
      assert_raises(ActiveRecord::RecordNotFound) {
        post :ipn_notification, params: { pay_key: 'ashfakjsdf', status: 'Invalid' }
      }
    end

    it 'should throw an error if ipn is not verified' do
      PaypalAdaptive::IpnNotification.any_instance.stubs(:verified?).returns(false)
      assert_raises(StandardError, 'ipn could not be verified') {
        post :ipn_notification, params: { pay_key: 'ashfakjsdf', status: 'Invalid' }
      }
    end
  end
end
