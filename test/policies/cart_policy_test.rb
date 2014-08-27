require_relative '../test_helper'

describe CartPolicy do
  include PunditMatcher

  subject { CartPolicy.new(user, cart) }
  let(:cart) { FactoryGirl.create :cart }
  let(:user) { nil }

  describe "for a visitor" do
    it { subject.must_deny(:show)   }
    it { subject.must_deny(:edit)   }
    it { subject.must_deny(:update) }
  end

  describe "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_deny(:show)   }
    it { subject.must_deny(:edit)   }
    it { subject.must_deny(:update) }
  end

  describe "for the owning user" do
    let(:user) { cart.user }
    it { subject.must_permit(:show)   }
    it { subject.must_permit(:edit)   }
    it { subject.must_permit(:update) }
  end
end
