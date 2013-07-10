#
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

describe Invitation do

  it "has a valid Factory" do
    FactoryGirl.create(:invitation).should be_valid
  end

  it {should belong_to :sender}

  it {should validate_presence_of :name}
  it {should validate_presence_of :email}
  it {should validate_presence_of :relation}
  it {should validate_presence_of :trusted_1}
  it {should validate_presence_of :trusted_2}

  it "!validates the sender" do
    @invitation = FactoryGirl.create(:invitation)
    @invitation.validate_sender.should eq false
  end

  it "validates the sender" do
    @invitation = FactoryGirl.create(:invitation)
    @invitation.sender.trustcommunity = true
    @invitation.validate_sender.should eq true
  end
end
