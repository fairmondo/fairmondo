#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class AddressPolicyTest < ActiveSupport::TestCase
  include PunditMatcher
  let(:address) { build(:address) }

  describe 'for a visitor' do
    it { refute_permit(nil, address, :create) }
    it { refute_permit(nil, address, :new) }
    it { refute_permit(nil, address, :edit) }
    it { refute_permit(nil, address, :update) }
    it { refute_permit(nil, address, :show) }
    it { refute_permit(nil, address, :destroy) }
  end

  describe 'for a random logged in user' do
    let(:user) { build(:user) }
    it { refute_permit(user, address, :create) }
    it { refute_permit(user, address, :new) }
    it { refute_permit(user, address, :edit) }
    it { refute_permit(user, address, :update) }
    it { refute_permit(user, address, :show) }
    it { refute_permit(user, address, :destroy) }
  end

  describe 'for logged in owner of address' do
    let(:user) { build(:incomplete_user) }
    let(:address) { build(:address, user: user) }

    it { assert_permit(user, address, :create) }
    it { assert_permit(user, address, :new) }
    it { assert_permit(user, address, :edit) }
    it { assert_permit(user, address, :update) }
    it { assert_permit(user, address, :show) }
    it { assert_permit(user, address, :destroy) }
  end
end
