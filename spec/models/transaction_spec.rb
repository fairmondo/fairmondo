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

describe Transaction do
  describe "associations" do
    it { should have_one :article }
  end

  describe "model attributes" do
    it { should respond_to :type }
    it { should respond_to :selected_transport }
    it { should respond_to :selected_payment }
    it { should respond_to :tos_accepted }
  end

  describe "enumerization" do
    it { should enumerize(:selected_transport).in(:pickup, :insured, :uninsured) }
    it { should enumerize(:selected_payment).in(:bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice) }
  end

  describe "methods" do
    let (:transaction) { FactoryGirl.create :transaction }

    describe "that are public" do
      describe "#edit_params_valid?" do
        it "should return true with valid params" do
          r = transaction.edit_params_valid? "transaction" => {"selected_transport" => "pickup", "selected_payment" => "cash"}
          r.should be_true
        end

        it "should return false with invalid transport" do
          r = transaction.edit_params_valid? "transaction" => {"selected_transport" => "insured", "selected_payment" => "cash"}
          r.should be_false
        end

        it "should return false with invalid payment" do
          r = transaction.edit_params_valid? "transaction" => {"selected_transport" => "pickup", "selected_payment" => "paypal"}
          r.should be_false
        end
      end

      describe "#selected_transports" do
        it "should call the private #selected method" do
          transaction.should_receive(:selected).with("transport")
          transaction.selected_transports
        end
      end

      describe "#selected_payments" do
        it "should call the private #selected method" do
          transaction.should_receive(:selected).with("payment")
          transaction.selected_payments
        end
      end
    end

    describe "that are private" do
      describe "#selected" do
        it "should get the article's selectable attributes" do
          transaction.article.should_receive(:selectable).with("transport").and_return(["pickup"])
          transaction.selected_transports
        end

        it "should return an Array with selected attributes and their localizations" do
          transaction.selected_transports.should eq [[I18n.t("enumerize.transaction.selected_transport.pickup"), "pickup"]]
        end
      end
    end
  end
end
