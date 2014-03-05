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
require 'spec_helper'

describe PaymentsController do
  render_views

  let(:payment) { Payment.create(transaction: transaction, pay_key: 'foobar') }
  let(:transaction) { FactoryGirl.create(:transaction_with_buyer, selected_payment: :paypal) }
  let(:buyer) { transaction.buyer }

  before { sign_in buyer }

  describe "POST 'create'" do
    it "should create a payment and forward to show" do
      expect do
        post :create, transaction_id: transaction.id
      end.to change(Payment, :count).by 1
      response.should redirect_to "http://test.host/payments/1"
    end

    it "should update a payment and forward to show" do
      payment #so one with the transaction_id already exists
      expect do
        post :create, transaction_id: transaction.id
      end.not_to change(Payment, :count)
      response.should redirect_to "http://test.host/payments/1"
    end
  end

  describe "GET 'show'" do
    it "should redirect to paypal" do
      get :show, id: payment.id
      response.should redirect_to "https://www.sandbox.paypal.com/de/webscr?cmd=_ap-payment&paykey=foobar"
    end
  end
end