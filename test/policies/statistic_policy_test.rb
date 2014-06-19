require_relative '../test_helper'

describe StatisticPolicy do
  include PunditMatcher

  subject { StatisticPolicy.new(user, statistic) }
  let(:statistic) { Statistic.new }
  let(:user) { nil }

  describe "for a visitor" do
    it { subject.must_deny(:general)        }
    it { subject.must_deny(:category_sales) }
  end

  describe "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_deny(:general)            }
    it { subject.must_deny(:category_sales)     }
  end

  describe "for an admin user" do
    let(:user) { FactoryGirl.create :admin_user }
    it { subject.must_permit(:general)                }
    it { subject.must_permit(:category_sales)         }
  end
end
