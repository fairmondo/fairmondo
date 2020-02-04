#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class StatisticPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  let(:statistic) { Statistic.new }
  let(:user) { nil }

  describe 'for a visitor' do
    it { refute_permit(user, statistic, :general)        }
    it { refute_permit(user, statistic, :category_sales) }
  end

  describe 'for a random logged-in user' do
    let(:user) { build :user }
    it { refute_permit(user, statistic, :general)            }
    it { refute_permit(user, statistic, :category_sales)     }
  end

  describe 'for an admin user' do
    let(:user) { build :admin_user }
    it { assert_permit(user, statistic, :general)                }
    it { assert_permit(user, statistic, :category_sales)         }
  end
end
