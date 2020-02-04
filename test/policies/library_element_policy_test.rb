#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class LibraryElementPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  subject { LibraryElementPolicy.new(user, library_element)   }
  let(:library_element) { create :library_element }
  let(:user) { nil }

  describe 'for a visitor' do
    it { subject.must_deny(:create)  }
    it { subject.must_deny(:destroy) }
  end

  describe 'for a random logged-in user' do
    let(:user) { create :user }
    it { subject.must_deny(:create)             }
    it { subject.must_deny(:destroy)            }
  end

  describe 'for the template owning user' do
    let(:user) { library_element.library.user }
    it { subject.must_permit(:create)               }
    it { subject.must_permit(:destroy)              }
  end
end
