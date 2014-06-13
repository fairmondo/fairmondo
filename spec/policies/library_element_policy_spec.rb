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

describe LibraryElementPolicy do
  include PunditMatcher

  subject { LibraryElementPolicy.new(user, library_element)   }
  let(:library_element) { FactoryGirl.create :library_element }
  let(:user) { nil }

  context "for a visitor" do
    it { should deny(:create)  }
    it { should deny(:destroy) }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should deny(:create)             }
    it { should deny(:destroy)            }
  end

  context "for the template owning user" do
    let(:user) { library_element.library.user }
    it { should grant_permission(:create)               }
    it { should grant_permission(:destroy)              }
  end
end
