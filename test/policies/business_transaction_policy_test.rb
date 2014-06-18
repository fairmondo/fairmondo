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

describe BusinessTransactionPolicy do
  include PunditMatcher

  subject { BusinessTransactionPolicy.new(user, business_transaction)  }
  let(:business_transaction) { FactoryGirl.create :single_transaction, :sold }
  let(:user) { nil }

  describe "for a visitor" do
    it { subject.must_permit(:edit)                        }
    it { subject.must_permit(:update)                      }
    it { subject.must_ultimately_deny(:show)               }
    it { subject.must_ultimately_deny(:print_order_seller) }
    it { subject.must_ultimately_deny(:print_order_buyer)  }
  end

  describe "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_permit(:edit)             }
    it { subject.must_permit(:update)           }
    it { subject.must_deny(:show)               }
    it { subject.must_deny(:print_order_seller) }
    it { subject.must_deny(:print_order_buyer)  }
  end

  describe "for the business_transaction seller" do
    let(:user) { business_transaction.article_seller }
    it { subject.must_deny(:edit)                 }
    it { subject.must_deny(:update)               }
    it { subject.must_permit(:show)               }
    it { subject.must_permit(:print_order_seller) }
  end

  describe "for the transaction buyer" do
    let(:user) { business_transaction.buyer          }
    it { subject.must_permit(:show)               }
    it { subject.must_permit(:print_order_buyer)  }
  end
end
