#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
