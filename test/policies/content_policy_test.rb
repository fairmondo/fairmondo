#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ContentPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  subject { ContentPolicy.new(user, content)   }
  let(:content) { build :content }
  let(:user) { nil }

  describe 'for a visitor' do
    it { assert_permit(user, content, :show)      }
    it { assert_permit(user, content, :not_found) }
    it { refute_permit(user, content, :index)       }
    it { refute_permit(user, content, :new)         }
    it { refute_permit(user, content, :create)      }
    it { refute_permit(user, content, :edit)        }
    it { refute_permit(user, content, :update)      }
    it { refute_permit(user, content, :destroy)     }
  end

  describe 'for a random logged-in user' do
    let(:user) { build :user }
    it { assert_permit(user, content, :show)      }
    it { assert_permit(user, content, :not_found) }
    it { refute_permit(user, content, :index)              }
    it { refute_permit(user, content, :new)                }
    it { refute_permit(user, content, :create)             }
    it { refute_permit(user, content, :edit)               }
    it { refute_permit(user, content, :update)             }
    it { refute_permit(user, content, :destroy)            }
  end

  describe 'for an admin user' do
    let(:user) { build :admin_user }
    it { assert_permit(user, content, :show)      }
    it { assert_permit(user, content, :not_found) }
    it { assert_permit(user, content, :index) }
    it { assert_permit(user, content, :new)                    }
    it { assert_permit(user, content, :create)                 }
    it { assert_permit(user, content, :edit)                   }
    it { assert_permit(user, content, :update)                 }
    it { assert_permit(user, content, :destroy)                }
  end
end
