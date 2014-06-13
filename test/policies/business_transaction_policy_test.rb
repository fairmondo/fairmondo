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
require 'test_helper'

describe BusinessTransactionPolicy do
  include PunditMatcher

  subject { BusinessTransactionPolicy.new(user, business_transaction)  }
  let(:business_transaction) { FactoryGirl.create :single_transaction, :sold }
  let(:user) { nil }

  context "for a visitor" do
    it { should grant_permission(:edit)                        }
    it { should grant_permission(:update)                      }
    it { should ultimately_deny(:show)               }
    it { should ultimately_deny(:print_order_seller) }
    it { should ultimately_deny(:print_order_buyer)  }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should grant_permission(:edit)             }
    it { should grant_permission(:update)           }
    it { should deny(:show)               }
    it { should deny(:print_order_seller) }
    it { should deny(:print_order_buyer)  }
  end

  context "for the business_transaction seller" do
    let(:user) { business_transaction.article_seller }
    it { should deny(:edit)                 }
    it { should deny(:update)               }
    it { should grant_permission(:show)               }
    it { should grant_permission(:print_order_seller) }
  end

  context "for the transaction buyer" do
    let(:user) { business_transaction.buyer          }
    it { should grant_permission(:show)               }
    it { should grant_permission(:print_order_buyer)  }
  end
end
