require 'spec_helper'

describe StatisticPolicy do
  include PunditMatcher

  subject { StatisticPolicy.new(user, statistic) }
  let(:statistic) { Statistic.new }
  let(:user) { nil }

  context "for a visitor" do
    it { should deny(:general)        }
    it { should deny(:category_sales) }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should deny(:general)            }
    it { should deny(:category_sales)     }
  end

  context "for an admin user" do
    let(:user) { FactoryGirl.create :admin_user }
    it { should grant_permission(:general)                }
    it { should grant_permission(:category_sales)         }
  end
end
