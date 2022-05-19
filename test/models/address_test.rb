#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  let(:address) { create(:address) }
  subject { Address.new }

  it 'has a valid factory' do
    _(address.valid?).must_equal true
  end

  describe 'associations' do
    should belong_to :user
    should have_many :payment_address_references
    should have_many :transport_address_references
  end

  describe 'attributes' do
    it { _(subject).must_respond_to :title }
    it { _(subject).must_respond_to :first_name }
    it { _(subject).must_respond_to :last_name }
    it { _(subject).must_respond_to :company_name }
    it { _(subject).must_respond_to :address_line_1 }
    it { _(subject).must_respond_to :address_line_2 }
    it { _(subject).must_respond_to :zip }
    it { _(subject).must_respond_to :city }
    it { _(subject).must_respond_to :country }
    it { _(subject).must_respond_to :user_id }
    it { _(subject).must_respond_to :stashed }
    it { _(address.stashed).must_equal false } # should default to false
  end

  describe 'validations' do
    should validate_presence_of :first_name
    should validate_presence_of :last_name
    should validate_presence_of :address_line_1
    should validate_presence_of :zip
    should validate_presence_of :city
    should validate_presence_of :country
  end

  describe '#duplicate_if_referenced!' do
    it 'returns the original model if it is not referenced and not changed' do
      _(address).must_equal address.duplicate_if_referenced!
      _(address.stashed).must_equal false
    end
    it 'returns the original model if it is not referenced and changed' do
      address.assign_attributes(first_name: 'not_the_original_value')
      _(address).must_equal address.duplicate_if_referenced!
      _(address.stashed).must_equal false
    end
    it 'returns an unsaved new instance if it is referenced and changed' do
      old_name = address.first_name
      new_name = 'not_the_original_value'
      create(:line_item_group, payment_address: address)
      address.assign_attributes(first_name: new_name)
      new_address = address.duplicate_if_referenced!
      _(new_address.new_record?).must_equal true
      _(new_address.first_name).must_equal new_name
      _(address.reload.first_name).must_equal old_name # should not change
      _(address.stashed?).must_equal true
    end
  end

  describe '#is_referenced?' do
    it 'should return false if not referenced' do
      _(address.is_referenced?).must_equal false
    end

    it 'should return true if referenced as payment address' do
      create(:line_item_group, payment_address: address)
      _(address.is_referenced?).must_equal true
    end

    it 'should return true if referenced as transport address' do
      create(:line_item_group, transport_address: address)
      _(address.is_referenced?).must_equal true
    end
  end

  describe '#stash!' do
    it 'stashes the record' do
      address.stash!
      _(address.reload.stashed?).must_equal true
    end
  end

  describe 'string representation' do
    it 'should output all business address fields in a single line' do
      address = build_stubbed(:address_for_alice)

      assert_equal(
        'Fairix eG, Frau Alice Henderson, Heidestraße 17, c/o Fairix eG, 51147 Köln, Deutschland',
        address.to_s
      )
    end

    it 'should output all private address fields in a single line' do
      address = build_stubbed(:address)

      assert_equal(
        'Erika Mustermann, Heidestraße 17, 51147 Köln, Deutschland',
        address.to_s
      )
    end
  end
end
