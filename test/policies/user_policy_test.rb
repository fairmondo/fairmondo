#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  include PunditMatcher
  subject { UserPolicy.new(user, resource)  }
  let(:resource) { create :user }
  let(:user) { nil }

  describe 'for a visitor' do
    it { subject.must_permit(:show)    }
    it { subject.must_permit(:profile) }
  end

  describe 'for a random logged-in user' do
    let(:user) { create :user }

    it { subject.must_permit(:show)             }
    it { subject.must_permit(:profile)          }
  end
end
