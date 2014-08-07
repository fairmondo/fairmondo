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

describe PaymentPolicy do
  include PunditMatcher

  subject { PaymentPolicy.new(user, payment)  }
  let(:bt) { FactoryGirl.create(:business_transaction, :paypal) }
  let(:payment) { bt.payment }

  describe "for a visitor" do
    let(:user) { nil }
    it { subject.must_deny(:show)   }
    it { subject.must_deny(:update) }
  end

  describe "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_deny(:show)         }
    it { subject.must_deny(:update)       }
  end

  describe "for the buying user" do
    let(:user) { payment.line_item_group_buyer }
    it { subject.must_permit(:show)        }
    it { subject.must_permit(:update)      }
  end
end
