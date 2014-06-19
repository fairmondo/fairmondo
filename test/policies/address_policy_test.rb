require_relative '../test_helper'

describe AddressPolicy do
  include PunditMatcher
  subject { AddressPolicy.new(user, address) }
  let(:address_owner) { FactoryGirl.create(:user) }
  let(:address) { FactoryGirl.create(:address, user: address_owner) }

  context 'for a visitor' do
    let(:user) { nil }

    it { subject.must_deny(:index) }
    it { subject.must_deny(:create) }
    it { subject.must_deny(:new) }
    it { subject.must_deny(:edit) }
    it { subject.must_deny(:update) }
    it { subject.must_deny(:show) }
    it { subject.must_deny(:destroy) }
  end

  context 'for a random logged in user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:address) { address }

    it { subject.must_deny(:index) }
    it { subject.must_deny(:create) }
    it { subject.must_deny(:new) }
    it { subject.must_deny(:edit) }
    it { subject.must_deny(:update) }
    it { subject.must_deny(:show) }
    it { subject.must_deny(:destroy) }
  end

  context 'for logged in owner of address' do
    let(:user) { address_owner }

    it { subject.must_permit(:index) }
    it { subject.must_permit(:create) }
    it { subject.must_permit(:new) }
    it { subject.must_permit(:edit) }
    it { subject.must_permit(:update) }
    it { subject.must_permit(:show) }
    it { subject.must_permit(:destroy) }
  end
end
