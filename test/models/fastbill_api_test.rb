require_relative '../test_helper'
include FastBillStubber

describe FastbillAPI do
  describe "methods" do

    let( :business_transaction ) { BusinessTransaction.new }
    let( :db_business_transaction ) { FactoryGirl.create :business_transaction }
    let( :seller ) { db_business_transaction.seller }

    describe "::fastbill_chain" do
      it "should find seller of transaction" do
        FastbillAPI.fastbill_chain( db_business_transaction )
      end

      describe "when seller is an NGO" do
        it "should not contact Fastbill" do
          Fastbill::Automatic::Base.expects( :perform ).never
          FastbillAPI.fastbill_chain( db_business_transaction )
        end
      end

      describe "when seller is not an NGO" do
        describe "and has Fastbill profile" do

          it "should not create new Fastbill profile" do
            db_business_transaction # to trigger observers before
            FastbillAPI.expects( :fastbill_create_customer ).never
            FastbillAPI.expects( :fastbill_create_subscription ).never
            FastbillAPI.fastbill_chain( db_business_transaction )
          end
        end

        describe "and has no Fastbill profile" do
          let( :db_business_transaction ) { FactoryGirl.create :business_transaction, :clear_fastbill }
          it "should create new Fastbill profile" do
            db_business_transaction # to trigger observers before
            FastbillAPI.expects( :fastbill_create_customer )
            FastbillAPI.expects( :fastbill_create_subscription )
            FastbillAPI.fastbill_chain( db_business_transaction )
          end
        end

        it "should set usage data for subscription" do
          db_business_transaction # to trigger observers before
          FastbillAPI.expects( :fastbill_setusagedata ).twice
          FastbillAPI.fastbill_chain( db_business_transaction )
        end
      end

      describe 'article price is 0Euro' do
        let(:article) { FactoryGirl.create :article, price: Money.new(0) }
        it 'should not call FastbillAPI' do
          FastbillAPI.expects(:fastbill_chain).never
          article.business_transaction.buy
        end
      end
    end

    describe '::fastbill_discount' do
      it 'should call setusagedata' do
        db_business_transaction # to trigger observers before
        Fastbill::Automatic::Subscription.expects( :setusagedata )
        db_business_transaction.discount = FactoryGirl.create :discount
        FastbillAPI.fastbill_discount(seller, db_business_transaction)
      end
    end

    describe '::fastbill_refund' do
      it 'should call setusagedata' do
        db_business_transaction # to trigger observers before
        Fastbill::Automatic::Subscription.expects( :setusagedata ).twice
        FastbillAPI.fastbill_refund( db_business_transaction, :fair )
        FastbillAPI.fastbill_refund( db_business_transaction, :fee )
      end
    end

    # describe '::update_profile' do
    #   it 'should call setusagedata' do
    #     Fastbill::Automatic::Customer.expects( :get )
    #     FastbillAPI.update_profile( seller )
    #   end
    # end

    describe '::discount_wo_vat' do
      it 'should receive call' do
        FastbillAPI.expects( :discount_wo_vat )
        FastbillAPI.discount_wo_vat( db_business_transaction )
      end
    end
  end
end
