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

describe LibraryPolicy do
  include PunditMatcher

  subject { LibraryPolicy.new(user, library)  }
  let(:library) { FactoryGirl.create :library }
  let(:user)    { nil                         }

  describe 'for a visitor' do
    it { subject.must_deny(:show)         }
    it { subject.must_deny(:create)       }
    it { subject.must_deny(:update)       }
    it { subject.must_deny(:destroy)      }
    it { subject.must_deny(:admin_add)    }
    it { subject.must_deny(:admin_remove) }
  end

  describe 'for a random logged-in user' do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_deny(:show)               }
    it { subject.must_deny(:create)             }
    it { subject.must_deny(:update)             }
    it { subject.must_deny(:destroy)            }
    it { subject.must_deny(:admin_add)          }
    it { subject.must_deny(:admin_remove)       }
  end

  describe 'for the library owning user' do

    let(:user) { library.user       }
    it { subject.must_permit(:show)       }
    it { subject.must_permit(:create)     }
    it { subject.must_permit(:update)     }
    it { subject.must_permit(:destroy)    }
    it { subject.must_deny(:admin_add)    }
    it { subject.must_deny(:admin_remove) }
  end

  describe 'for an admin' do
    let(:user) { FactoryGirl.create :admin_user }
    it { subject.must_permit(:admin_add)              }
    it { subject.must_permit(:admin_remove)           }
  end
end
