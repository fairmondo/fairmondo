#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class StatisticPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  subject { StatisticPolicy.new(user, statistic) }
  let(:statistic) { Statistic.new }
  let(:user) { nil }

  describe 'for a visitor' do
    it { subject.must_deny(:general)        }
    it { subject.must_deny(:category_sales) }
  end

  describe 'for a random logged-in user' do
    let(:user) { create :user }
    it { subject.must_deny(:general)            }
    it { subject.must_deny(:category_sales)     }
  end

  describe 'for an admin user' do
    let(:user) { create :admin_user }
    it { subject.must_permit(:general)                }
    it { subject.must_permit(:category_sales)         }
  end
end
