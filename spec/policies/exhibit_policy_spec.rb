require 'spec_helper'

describe ExhibitPolicy do
  include PunditMatcher

  subject { ExhibitPolicy.new(user, exhibit)   }
  let(:exhibit) { FactoryGirl.create :exhibit }
  let(:user) { nil }

  context "for a visitor" do
    it { should deny(:create)      }
    it { should deny(:create_multiple)      }
    it { should deny(:update)      }
    it { should deny(:destroy)     }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }

    it { should deny(:create)      }
    it { should deny(:create_multiple)      }
    it { should deny(:update)      }
    it { should deny(:destroy)     }
  end

  context "for an admin user" do
    let(:user) { FactoryGirl.create :admin_user }

    it { should grant_permission(:create)      }
    it { should grant_permission(:create_multiple)      }
    it { should grant_permission(:update)      }
    it { should grant_permission(:destroy)     }

  end
end
