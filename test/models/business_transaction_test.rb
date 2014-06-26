#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

describe PartialFixedPriceTransaction do
  subject { PartialFixedPriceTransaction.new }

  describe "attributes" do
    it { subject.must_respond_to :quantity_bought }
  end
end

class BusinessTransactionTest < ActiveSupport::TestCase
  subject { BusinessTransaction.new }
  describe "attributes" do
    it { subject.must_respond_to :selected_transport }
    it { subject.must_respond_to :selected_payment }
    it { subject.must_respond_to :tos_accepted }
    it { subject.must_respond_to :message }
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :type }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :expire }
    it { subject.must_respond_to :buyer_id }
    it { subject.must_respond_to :state }
    it { subject.must_respond_to :parent_id }
    it { subject.must_respond_to :article_id }
    it { subject.must_respond_to :forename }
    it { subject.must_respond_to :surname }
    it { subject.must_respond_to :street }
    it { subject.must_respond_to :address_suffix }
    it { subject.must_respond_to :city }
    it { subject.must_respond_to :zip }
    it { subject.must_respond_to :country }
    it { subject.must_respond_to :seller_id }
    it { subject.must_respond_to :sold_at }
    it { subject.must_respond_to :purchase_emails_sent }
    it { subject.must_respond_to :discount_id }
    it { subject.must_respond_to :discount_value_cents }
    it { subject.must_respond_to :billed_for_fair }
    it { subject.must_respond_to :billed_for_fee }
    it { subject.must_respond_to :billed_for_discount }
  end

  describe "associations" do
    it { subject.must belong_to :article }
    it { subject.must belong_to :buyer  }
  end

  describe "enumerization" do # I asked for clarification on how to do this: https://github.com/brainspec/enumerize/issues/136 - maybe comment back in when we have a positive response.
    should enumerize(:selected_transport).in(:pickup, :type1, :type2)
    should enumerize(:selected_payment).in(:bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice)
  end

  describe "methods" do
    let(:business_transaction) { FactoryGirl.create :super_transaction }

    describe "that are public" do

      describe "#selected_transports" do
        it "should call the private #selected method" do
          business_transaction.expects(:selected).with("transport")
          business_transaction.selected_transports
        end
      end

      describe "#selected_payments" do
        it "should call the private #selected method" do
          business_transaction.expects(:selected).with("payment")
          business_transaction.selected_payments
        end
      end

      describe "#selected?" do
        it "should return true when the seller selected a specific transport/payment type" do
          business_transaction.selected?('transport', 'pickup').must_equal true
        end

        it "should return false when the seller didn't select spcified type" do
          business_transaction.selected?('payment', 'paypal').must_equal false
        end
      end
    end

    describe "that are protected" do
      it "should generally not allow quantity_available" do
        proc { business_transaction.quantity_available }.must_raise NoMethodError
      end
      it "should generally not allow quantity_bought" do
        proc { business_transaction.quantity_bought }.must_raise NoMethodError
      end
    end

    describe "that are private" do
      describe "#selected" do
        it "should get the article's selectable attributes" do
          business_transaction.article.expects(:selectable).with("transport").returns(["pickup"])
          business_transaction.selected_transports
        end

        it "should return an Array with selected attributes and their localizations" do
          business_transaction.selected_transports.must_equal [[I18n.t("enumerize.business_transaction.selected_transport.pickup"), "pickup"],
                                                      [I18n.t("enumerize.business_transaction.selected_transport.type1"),"type1"],
                                                      [I18n.t("enumerize.business_transaction.selected_transport.type2"),"type2"]]
        end
      end
    end
  end
end

describe MultipleFixedPriceTransaction do
  let(:mfpt) { MultipleFixedPriceTransaction.new }
  subject { mfpt }

  describe "attributes" do
    it { subject.must_respond_to :quantity_available }
  end

  it "should have a valid factory" do
    assert_difference 'BusinessTransaction.count', 1 do
      FactoryGirl.create :multiple_transaction
    end
    t = BusinessTransaction.last
    t.type.must_equal "MultipleFixedPriceTransaction"
    t.article.must_be_instance_of Article
    t.article_quantity.must_be :>, 1
  end

  it "should be generated with an article that has a quantity of more than one" do
    assert_difference 'BusinessTransaction.count', 1 do
      FactoryGirl.create :article, quantity: 2
    end
    Article.last.business_transaction.must_be_instance_of MultipleFixedPriceTransaction
  end

  describe "methods" do
    describe "#buy_multiple_transaction" do

      describe "when quantity_bought is greater than the available quantity" do
        it "should add an error" do
          mfpt.quantity_available = 2
          mfpt.quantity_bought = 3
          mfpt.send(:buy_multiple_business_transactions)
          mfpt.errors[:quantity_bought].wont_be_nil
        end
      end

      describe "when quantity_bought is lower than (or equal to) the available quantity" do
        before do
          mfpt.quantity_available = 3
          mfpt.quantity_bought = 2
          mfpt.buyer = User.new id: 1
          mfpt.article = Article.new
        end

        it "should create a new PartialFixedPriceTransaction with the correct data" do
          PartialFixedPriceTransaction.any_instance.stubs(:buy)
          PartialFixedPriceTransaction.any_instance.expects(:save!).returns(true)
          #...
          mfpt.send(:buy_multiple_business_transactions)
        end

        it "should trigger the buy event on the new PartialFixedPriceTransaction" do
          mfpt.save
          PartialFixedPriceTransaction.any_instance.stubs(:save!)
          mfpt.stubs(:save!)
          PartialFixedPriceTransaction.any_instance.expects(:buy).returns(true)
          mfpt.send(:buy_multiple_business_transactions)
        end
      end
    end


  end
end

describe SingleFixedPriceTransaction do
  let(:fpt) { SingleFixedPriceTransaction.new }
  subject { fpt }

  it "should have a valid factory" do
    assert_difference 'BusinessTransaction.count', 1 do
      FactoryGirl.create :single_transaction
    end

    t = BusinessTransaction.last
    t.type.must_equal "SingleFixedPriceTransaction"
    t.article.must_be_instance_of Article
    t.article_quantity.must_equal 1
  end

  it "should be generated with an article that has a quantity one" do
    assert_difference 'BusinessTransaction.count', 1 do
      FactoryGirl.create :article
    end
    Article.last.business_transaction.must_be_instance_of SingleFixedPriceTransaction
  end

  describe "attributes" do
    it { subject.must_respond_to 'quantity_bought' }
    it "should read quantity_bought, and it should always be one" do
      fpt.send(:quantity_bought=, 3)
      fpt.send(:quantity_bought).must_equal 1
    end
  end

  describe "methods" do
    describe "#total_price" do
      it "should forward the call to article" do
        fpt.article = Article.new
        fpt.article.expects(:total_price)
        fpt.total_price
      end
    end
  end

end
