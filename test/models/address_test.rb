require_relative '../test_helper'

describe Address do
  let(:address) { FactoryGirl.create(:address) }
  subject { Address.new }

  it 'has a valid factory' do
    address.valid?.must_equal true
  end

  describe 'associations' do
    it { subject.must belong_to :user }
    it { subject.must have_many :payment_address_references }
    it { subject.must have_many :transport_address_references }
  end

  describe 'attributes' do
    it { subject.must_respond_to :title }
    it { subject.must_respond_to :first_name }
    it { subject.must_respond_to :last_name }
    it { subject.must_respond_to :company_name }
    it { subject.must_respond_to :address_line_1 }
    it { subject.must_respond_to :address_line_2 }
    it { subject.must_respond_to :zip }
    it { subject.must_respond_to :city }
    it { subject.must_respond_to :country }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :stashed }
    it { address.stashed.must_equal false } # should default to false
  end

  describe 'validations' do
    it { subject.must validate_presence_of :first_name }
    it { subject.must validate_presence_of :last_name }
    it { subject.must validate_presence_of :address_line_1 }
    it { subject.must validate_presence_of :zip }
    it { subject.must validate_presence_of :city }
    it { subject.must validate_presence_of :country }
  end

  describe '#duplicate_if_referenced!' do
    it "returns the original model if it is not referenced and not changed" do
      address.must_equal address.duplicate_if_referenced!
      address.stashed.must_equal false
    end
    it "returns the original model if it is not referenced and changed" do
      address.assign_attributes(first_name: "not_the_original_value")
      address.must_equal address.duplicate_if_referenced!
      address.stashed.must_equal false
    end
    it "returns an unsaved new instance if it is referenced and changed" do
      old_name = address.first_name
      new_name = "not_the_original_value"
      FactoryGirl.create(:line_item_group, payment_address: address)
      address.assign_attributes(first_name: new_name)
      new_address = address.duplicate_if_referenced!
      new_address.new_record?.must_equal true
      new_address.first_name.must_equal new_name
      address.reload.first_name.must_equal old_name # should not change
      address.stashed?.must_equal true
    end
  end

  describe '#is_referenced?' do
    it "should return false if not referenced" do
      address.is_referenced?.must_equal false
    end
    it "should return true if referenced as payment address" do
      FactoryGirl.create(:line_item_group, payment_address: address)
      address.is_referenced?.must_equal true
    end
    it "should return true if referenced as transport address" do
      FactoryGirl.create(:line_item_group, transport_address: address)
      address.is_referenced?.must_equal true
    end
  end

  describe '#stash!' do
    it "stashes the record" do
      address.stash!
      address.reload.stashed?.must_equal true
    end
  end
end
