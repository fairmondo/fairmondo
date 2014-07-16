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
include FastBillStubber

describe PaymentsController do

  let(:payment) { FactoryGirl.create(:payment) }
  let(:bt) { FactoryGirl.create(:business_transaction, :paypal_purchasable, payment: payment) }
  let(:buyer) { bt.buyer }

  before do
    stub_fastbill
    sign_in buyer
  end

  describe "POST 'create'" do
    it "should create a payment and forward to show" do
      assert_difference 'Payment.count', 1 do
        post :create, business_transaction_id: bt.id
      end
      assert_redirected_to "http://test.host/payments/1"
    end

    it "should update a payment and forward to show" do
      payment #so one with the business_transaction_id already exists
      assert_difference 'Payment.count', 0 do
        post :create, business_transaction_id: bt.id
      end
      assert_redirected_to "http://test.host/payments/1"
    end
  end

  describe "GET 'show'" do
    it "should redirect to paypal" do
      get :show, id: payment.id
      assert_redirected_to "https://www.sandbox.paypal.com/de/webscr?cmd=_ap-payment&paykey=foobar"
    end
  end
end