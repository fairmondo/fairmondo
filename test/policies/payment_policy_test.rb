#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe PaymentPolicy do
  include PunditMatcher

  subject { PaymentPolicy.new(user, payment)  }
  let(:lig) { payment.line_item_group }
  let(:payment) { create(:paypal_payment) }

  describe 'for a visitor' do
    let(:user) { nil }
    it { subject.must_deny(:show)   }
    it { subject.must_deny(:create) }
  end

  describe 'for a random logged-in user' do
    let(:user) { create :user }
    it { subject.must_deny(:show)         }
    it { subject.must_deny(:create)       }
  end

  describe 'for the buying user' do
    let(:user) { payment.line_item_group_buyer }
    it { subject.must_permit(:show)        }
    it { subject.must_permit(:create)      }
  end
end
