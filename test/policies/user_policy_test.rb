#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  include PunditMatcher
  let(:resource) { build :user }
  let(:user) { nil }

  describe 'for a visitor' do
    it { assert_permit(user, resource, :show)    }
    it { assert_permit(user, resource, :profile) }
  end

  describe 'for a random logged-in user' do
    let(:user) { build :user }

    it { assert_permit(user, resource, :show) }
    it { assert_permit(user, resource, :profile) }
  end
end
