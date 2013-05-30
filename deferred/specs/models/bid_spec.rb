#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe Bid do
  let(:bid) { FactoryGirl.create(:bid) }
  subject { bid }

  it "has a valid Factory" do
    should be_valid
  end

  it {should validate_presence_of :user_id}
  it {should validate_presence_of :auction_transaction_id}
  it {should validate_presence_of :price_cents}

  # describe "check_better method" do
  #   context "when article.transaction has a max_bid" do
  #     it "should throw an error when bid is smaller than max_bid" do
  #       max_bid.should be_true
  #     end
  #   end
  # end

=begin
  it "checks that bid only accepts bids greater than the previous bid" do
    @bid = FactoryGirl.create(:bid)
    @bid.price_cents = Random.new.rand(1..500000)
    @bid.auction_transaction.max_bid = @bid.price_cents + Random.new.rand(1..500000)
    @bid.check_better.should eq false
  end
=end

end