require_relative '../test_helper'

describe AddressPolicy do
  include PunditMatcher
  subject { AddressPolicy.new(user, address) }
  let(:address) { FactoryGirl.create(:address, :with_user) }
  let(:user) { nil }

  context 'for a visitor' do
    it { subject.must_ultimately_deny(:index) }
    it { subject.must_ultimately_deny(:create) }
    it { subject.must_ultimately_deny(:new) }
    it { subject.must_ultimately_deny(:edit) }
    it { subject.must_ultimately_deny(:update) }
    it { subject.must_ultimately_deny(:show) }
    it { subject.must_ultimately_deny(:destroy) }
  end

  context 'for a random logged in user' do
    let(:user) { FactoryGirl.create(:user) }

    it { subject.must_ultimately_deny(:index) }
    it { subject.must_ultimately_deny(:create) }
    it { subject.must_ultimately_deny(:new) }
    it { subject.must_ultimately_deny(:edit) }
    it { subject.must_ultimately_deny(:update) }
    it { subject.must_ultimately_deny(:show) }
    it { subject.must_ultimately_deny(:destroy) }
  end

  context 'for logged in owner of address' do
    let(:user) { address.user }

    it { subject.must_permit(:index) }
    it { subject.must_permit(:create) }
    it { subject.must_permit(:new) }
    it { subject.must_permit(:edit) }
    it { subject.must_permit(:update) }
    it { subject.must_permit(:show) }
    it { subject.must_permit(:destroy) }
  end
end
