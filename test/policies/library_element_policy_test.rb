#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LibraryElementPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  let(:library_element) { build :library_element }
  let(:user) { nil }

  describe 'for a visitor' do
    it { refute_permit(user, library_element, :create)  }
    it { refute_permit(user, library_element, :destroy) }
  end

  describe 'for a random logged-in user' do
    let(:user) { create :user }
    it { refute_permit(user, library_element, :create)             }
    it { refute_permit(user, library_element, :destroy)            }
  end

  describe 'for the template owning user' do
    let(:user) { library_element.library.user }
    it { assert_permit(user, library_element, :create)               }
    it { assert_permit(user, library_element, :destroy)              }
  end
end
