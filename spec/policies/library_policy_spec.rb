require 'spec_helper'

describe LibraryPolicy do
  include PunditMatcher

  subject { LibraryPolicy.new(user, library)  }
  let(:library) { FactoryGirl.create :library }
  let(:user) { nil }

  context "for a visitor" do
    it { should deny(:create)  }
    it { should deny(:update)  }
    it { should deny(:destroy) }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should deny(:create)             }
    it { should deny(:update)             }
    it { should deny(:destroy)            }
  end

  context "for the template owning user" do
    let(:user) { library.user    }
    it { should permit(:create)  }
    it { should permit(:update)  }
    it { should permit(:destroy) }
  end
end