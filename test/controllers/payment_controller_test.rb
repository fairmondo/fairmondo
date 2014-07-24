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

  let(:payment) { bt.payment }
  let(:buyer) { bt.buyer }

  before do
    sign_in buyer
  end

  describe "POST 'create'" do
    let(:bt) { FactoryGirl.create(:business_transaction, :paypal_purchasable) }

    it "should update a payment and forward to show" do
      payment #so one with the business_transaction_id already exists
      payment.pay_key.must_be_nil
      assert_difference 'Payment.count', 0 do
        post :update, id: payment.id
      end
      payment.reload.pay_key.must_be_kind_of String
      assert_redirected_to "https://www.sandbox.paypal.com/de/webscr?cmd=_ap-payment&paykey=foobar"
    end
  end

  describe "GET 'show'" do
    let(:bt) { FactoryGirl.create(:business_transaction, :paypal_purchasable, payment: FactoryGirl.create(:payment, :with_pay_key)) }

    it "should redirect to paypal" do
      get :show, id: payment.id
      assert_redirected_to "https://www.sandbox.paypal.com/de/webscr?cmd=_ap-payment&paykey=foobar"
    end
  end
end