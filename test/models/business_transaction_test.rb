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
    it { subject.must_respond_to :seller_id }
    it { subject.must_respond_to :sold_at }
    it { subject.must_respond_to :purchase_emails_sent }
    it { subject.must_respond_to :discount_id }
    it { subject.must_respond_to :discount_value_cents }
    it { subject.must_respond_to :billed_for_fair }
    it { subject.must_respond_to :billed_for_fee }
    it { subject.must_respond_to :billed_for_discount }
    it { subject.must_respond_to :transport_address_id }
    it { subject.must_respond_to :payment_address_id }
  end

  describe "associations" do
    it { subject.must belong_to :article }
    it { subject.must belong_to :buyer  }
    it { subject.must belong_to :payment_address }
    it { subject.must belong_to :transport_address }
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


