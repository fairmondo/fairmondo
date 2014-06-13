require 'spec_helper'
include PunditMatcher

describe AddressPolicy do
  let(:address) { FactoryGirl.create(:address) }
  subject { AddressPolicy.new(user, address) }

  context 'for a visitor' do
    let(:user) { nil }

    it { should deny(:index) }
    it { should deny(:create) }
    it { should deny(:new) }
    it { should deny(:edit) }
    it { should deny(:update) }
    it { should deny(:show) }
    it { should deny(:destroy) }
  end

  context 'for a random logged in user' do
    let(:user) { FactoryGirl.create(:user) }

    it { should deny(:index) }
    it { should deny(:create) }
    it { should deny(:new) }
    it { should deny(:edit) }
    it { should deny(:update) }
    it { should deny(:show) }
    it { should deny(:destroy) }
  end

  context 'for logged in owner of address' do
    let(:user) { address.user }

    it { should grant_permission(:index) }
    it { should grant_permission(:create) }
    it { should grant_permission(:new) }
    it { should grant_permission(:edit) }
    it { should grant_permission(:update) }
    it { should grant_permission(:show) }
    it { should grant_permission(:destroy) }
  end
end
