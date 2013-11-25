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

    it { should permit(:create)      }
    it { should permit(:create_multiple)      }
    it { should permit(:update)      }
    it { should permit(:destroy)     }

  end
end
