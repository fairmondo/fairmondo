#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LibraryPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  let(:library) { build :library }
  let(:user)    { nil }

  describe 'for a visitor' do
    it { refute_permit(user, library, :show)         }
    it { refute_permit(user, library, :create)       }
    it { refute_permit(user, library, :update)       }
    it { refute_permit(user, library, :destroy)      }
    it { refute_permit(user, library, :admin_add)    }
    it { refute_permit(user, library, :admin_remove) }
  end

  describe 'for a random logged-in user' do
    let(:user) { build :user }
    it { refute_permit(user, library, :show)               }
    it { refute_permit(user, library, :create)             }
    it { refute_permit(user, library, :update)             }
    it { refute_permit(user, library, :destroy)            }
    it { refute_permit(user, library, :admin_add)          }
    it { refute_permit(user, library, :admin_remove)       }
  end

  describe 'for the library owning user' do
    let(:user) { library.user       }
    it { assert_permit(user, library, :show)       }
    it { assert_permit(user, library, :create)     }
    it { assert_permit(user, library, :update)     }
    it { assert_permit(user, library, :destroy)    }
    it { refute_permit(user, library, :admin_add)    }
    it { refute_permit(user, library, :admin_remove) }
  end

  describe 'for an admin' do
    let(:user) { build :admin_user }
    it { assert_permit(user, library, :admin_add)              }
    it { assert_permit(user, library, :admin_remove)           }
  end
end
