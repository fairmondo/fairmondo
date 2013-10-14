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

describe TransactionPolicy do
  include PunditMatcher

  subject { TransactionPolicy.new(user, transaction)  }
  let(:transaction) { FactoryGirl.create :single_transaction, :sold }
  let(:user) { nil }

  context "for a visitor" do
    it { should permit(:edit)                        }
    it { should permit(:update)                      }
    it { should ultimately_deny(:show)               }
    it { should ultimately_deny(:print_order_seller) }
    it { should ultimately_deny(:print_order_buyer)  }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should permit(:edit)             }
    it { should permit(:update)           }
    it { should deny(:show)               }
    it { should deny(:print_order_seller) }
    it { should deny(:print_order_buyer)  }
  end

  context "for the transaction seller" do
    let(:user) { transaction.article_seller }
    it { should deny(:edit)                 }
    it { should deny(:update)               }
    it { should permit(:show)               }
    it { should permit(:print_order_seller) }
  end

  context "for the transaction buyer" do
    let(:user) { transaction.buyer          }
    it { should permit(:show)               }
    it { should permit(:print_order_buyer)  }
  end
end
