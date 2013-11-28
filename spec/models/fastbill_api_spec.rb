require 'spec_helper'
include FastBillStubber

describe FastbillAPI do
  describe "methods" do
    before do
      stub_fastbill
    end

    let( :transaction ) { Transaction.new }
    let( :db_transaction ) { FactoryGirl.create :transaction_with_buyer }
    let( :seller ) { db_transaction.seller }

    describe "::fastbill_chain" do
      it "should find seller of transaction" do
        User.should_receive( :find ).with( seller.id ).and_return( seller )
        FastbillAPI.fastbill_chain( db_transaction )
      end

      context "seller is an NGO" do
        it "should not contact Fastbill" do
          Fastbill::Automatic::Base.should_not_receive( :perform )
          FastbillAPI.fastbill_chain( db_transaction )
        end
      end

      context "seller is not an NGO" do
        context "and has Fastbill profile" do
          let( :db_transaction ) { FactoryGirl.create :transaction_with_buyer, :fastbill_profile }
          it "should not create new Fastbill profile" do
            FastbillAPI.should_not_receive( :fastbill_create_customer )
            FastbillAPI.should_not_receive( :fastbill_create_subscription )
            FastbillAPI.fastbill_chain( db_transaction )
          end
        end

        context "and has no Fastbill profile" do
          it "should create new Fastbill profile" do
            FastbillAPI.should_receive( :fastbill_create_customer )
            FastbillAPI.should_receive( :fastbill_create_subscription )
            FastbillAPI.fastbill_chain( db_transaction )
          end
        end

        it "should set usage data for subscription" do
          FastbillAPI.should_receive( :fastbill_setusagedata ).twice
          FastbillAPI.fastbill_chain( db_transaction )
        end
      end
    end
  end
end
