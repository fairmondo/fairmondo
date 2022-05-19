#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class FastbillAPITest < ActiveSupport::TestCase
  let(:api) { FastbillAPI.new }

  describe 'methods' do
    let(:bt_from_legal_entity) { create :business_transaction_from_legal_entity }
    let(:bt_from_private_user) { create :business_transaction_from_private_user }
    let(:bt_from_ngo)          { create :business_transaction_from_ngo }
    let(:bt_from_marketplace_owner_account) { create :business_transaction_from_marketplace_owner_account }

    describe '::fastbill_chain' do
      it 'should find seller of transaction' do
        api = FastbillAPI.new bt_from_legal_entity
        api.instance_eval('@seller').must_equal bt_from_legal_entity.seller
      end

      describe 'when seller is a private user' do
        it 'should not contact Fastbill' do
          api = FastbillAPI.new bt_from_private_user
          api.fastbill_chain
          assert_not_requested :post, 'https://my_email:my_fastbill_api_key@app.monsum.com'\
                                      '/api/1.0/api.php'
        end
      end

      describe 'when seller is an NGO' do
        it 'should not contact Fastbill' do
          api = FastbillAPI.new bt_from_ngo
          api.fastbill_chain
          assert_not_requested :post, 'https://my_email:my_fastbill_api_key@app.monsum.com'\
                                      '/api/1.0/api.php'
        end
      end

      describe 'when seller is an account of the marketplace owner' do
        it 'should not contact Fastbill' do
          api = FastbillAPI.new bt_from_marketplace_owner_account
          api.fastbill_chain
          assert_not_requested :post, 'https://my_email:my_fastbill_api_key@app.monsum.com'\
                                      '/api/1.0/api.php'
        end
      end

      describe 'when seller is not an NGO' do
        describe 'and has Fastbill profile' do
          it 'should not create new Fastbill profile' do
            bt_from_legal_entity # to trigger observers before
            bt_from_legal_entity.seller.update_attributes(fastbill_id: '1234',
                                                          fastbill_subscription_id: '4321')
            api = FastbillAPI.new bt_from_legal_entity
            api.expects(:fastbill_create_customer).never
            api.expects(:fastbill_create_subscription).never
            api.fastbill_chain
            assert_requested :post, 'https://app.monsum.com/api/1.0/api.php', times: 2
          end
        end

        describe 'and has no Fastbill profile' do
          let(:bt_from_legal_entity) { create :business_transaction_from_legal_entity, :clear_fastbill }

          it 'should create new Fastbill profile' do
            bt_from_legal_entity # to trigger observers before
            api = FastbillAPI.new bt_from_legal_entity
            api.expects(:fastbill_create_customer)
            api.expects(:fastbill_create_subscription)
            api.fastbill_chain
          end

          it 'should log error if creating the profile raises an exception' do
            bt_from_legal_entity # to trigger observers before
            api = FastbillAPI.new bt_from_legal_entity
            Fastbill::Automatic::Customer.stubs(:create).then.raises(StandardError)
            ExceptionNotifier.expects(:notify_exception)

            api.fastbill_chain
          end
        end

        it 'should set usage data for subscription' do
          bt_from_legal_entity # to trigger observers before
          api = FastbillAPI.new bt_from_legal_entity
          Fastbill::Automatic::Subscription.expects(:setusagedata).twice
          api.fastbill_chain
        end

        it 'should log error if set usage data raises exception' do
          bt_from_legal_entity # to trigger observers before
          api = FastbillAPI.new bt_from_legal_entity
          Fastbill::Automatic::Subscription.stubs(:setusagedata).then.raises(StandardError)
          ExceptionNotifier.expects(:notify_exception).twice

          api.fastbill_chain
        end
      end

      describe 'article price is 0 Euro' do
        let(:article) { create :article, price: Money.new(0) }
        it 'should not call FastbillAPI' do
          api = FastbillAPI.new
          api.expects(:fastbill_chain).never
          create :business_transaction, article: article
        end
      end
    end

    describe '::fastbill_discount' do
      it 'should call setusagedata' do
        bt_from_legal_entity # to trigger observers before
        Fastbill::Automatic::Subscription.expects(:setusagedata)
        bt_from_legal_entity.discount = create :discount
        api = FastbillAPI.new bt_from_legal_entity
        api.send :fastbill_discount
      end
    end

    describe '::fastbill_refund' do
      it 'should call setusagedata' do
        bt_from_legal_entity # to trigger observers before
        Fastbill::Automatic::Subscription.expects(:setusagedata).twice
        api = FastbillAPI.new bt_from_legal_entity
        api.send :fastbill_refund_fair
        api.send :fastbill_refund_fee
      end
    end

    describe '::discount_wo_vat' do
      it 'should receive call' do
        bt_from_legal_entity.discount = create :discount
        api = FastbillAPI.new bt_from_legal_entity
        api.expects(:discount_wo_vat)
        api.fastbill_chain
      end
    end

    describe 'refund' do
      it 'should receive call' do
        FastbillAPI.any_instance.expects(:fastbill_refund_fair)
        FastbillAPI.any_instance.expects(:fastbill_refund_fee)
        FastbillRefundWorker.perform_async(bt_from_legal_entity.id)
      end
    end
  end

  describe '#payment_type_for' do
    let(:user) { build_stubbed(:legal_entity) }

    it 'should return "1" when payment method is invoice' do
      user.stubs(:payment_method).returns(:payment_by_invoice)
      api.send(:payment_type_for, user).must_equal '1'
    end

    it 'should return "2" when payment method is direct debit' do
      user.stubs(:payment_method).returns(:payment_by_direct_debit)
      api.send(:payment_type_for, user).must_equal '2'
    end
  end

  describe '#attributes_for' do
    it 'should return customer data if payment type is invoice' do
      alice = build_stubbed(:user_alice)
      alice.stubs(:payment_method).returns(:payment_by_invoice)

      attributes = api.send(:attributes_for, alice)

      attributes.must_equal(
        customer_type: 'business',
        organization: 'Fairix eG',
        salutation: 'Frau',
        first_name: 'Alice',
        last_name: 'Henderson',
        address: 'Heidestraße 17',
        address_2: 'c/o Fairix eG',
        zipcode: '51147',
        city: 'Köln',
        country_code: 'DE',
        language_code: 'DE',
        email: 'alice@fairix.com',
        currency_code: 'EUR',
        payment_type: '1',
        show_payment_notice: '1',
        bank_iban: '',
        bank_bic: '',
        bank_account_owner: '',
        bank_name: '',
        bank_account_mandate_reference: '',
        bank_account_mandate_reference_date: nil,
        bank_account_number: '',
        bank_code: ''
      )
    end

    it 'should return customer and direct debit data if payment type is direct debit' do
      alice = build_stubbed(:user_alice_with_bank_details)
      mandate = build_stubbed(:direct_debit_mandate_wo_user)
      alice.stubs(:active_direct_debit_mandate).returns(mandate)
      alice.stubs(:payment_method).returns(:payment_by_direct_debit)

      attributes = api.send(:attributes_for, alice)

      attributes.must_equal(
        customer_type: 'business',
        organization: 'Fairix eG',
        salutation: 'Frau',
        first_name: 'Alice',
        last_name: 'Henderson',
        address: 'Heidestraße 17',
        address_2: 'c/o Fairix eG',
        zipcode: '51147',
        city: 'Köln',
        country_code: 'DE',
        language_code: 'DE',
        email: 'alice@fairix.com',
        currency_code: 'EUR',
        payment_type: '2',
        show_payment_notice: '1',
        bank_iban: 'DE12500105170648489890',
        bank_bic: 'GENODEF1JEV',
        bank_account_owner: 'Alice Henderson',
        bank_name: 'GLS Gemeinschaftsbank',
        bank_account_mandate_reference: '1001-001',
        bank_account_mandate_reference_date: Date.parse('2016-04-01'),
        bank_account_number: '',
        bank_code: ''
      )
    end
  end
end
