require 'spec_helper'

describe UserPolicy do
  include PunditMatcher
  subject { UserPolicy.new(user, resource)  }
  let(:resource) { FactoryGirl.create :user }
  let(:user) { nil }

  context "for a visitor" do
    it { should deny(:show)    }
    it { should deny(:profile) }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }

    it { should permit(:show) }
    it { should permit(:profile)           }
  end


end
