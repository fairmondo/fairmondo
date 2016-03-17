#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe DirectDebitMandate do
  subject { DirectDebitMandate.new }
  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:direct_debit_mandate) { DirectDebitMandate.new(user: user) }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :reference }
  end

  describe 'associations' do
    it { subject.must belong_to(:user) }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :user_id }
    it { subject.must validate_uniqueness_of :user_id }
    it { subject.must validate_presence_of :reference }
  end

  describe 'initialization' do
    it 'should initialize a valid object' do
      assert direct_debit_mandate.valid?
    end

    it 'should not generate a new reference if one is already present' do
      direct_debit_mandate.save
      DirectDebitMandate.any_instance.stubs(:calculate_reference).returns('fake')
      mandate_new = DirectDebitMandate.find(direct_debit_mandate.id)
      mandate_new.reference.wont_equal 'fake'
    end
  end

  describe 'reference calculation' do
    it 'should create a hash reference based on current time and user_id' do
      Time.use_zone('CET') do
        Time.stubs(:now).returns(Time.new(2016, 1, 1))
        direct_debit_mandate.user_id = 1001
        direct_debit_mandate.reference.must_equal 'EFUUXKUPS45ELY81TBVMQV8TT'
      end
    end
  end

  describe 'class methods' do
    describe '#creditor_identifier' do
      it 'should return Fairmondo SEPA Creditor Identifier' do
        DirectDebitMandate.creditor_identifier.must_equal 'DE15ZZZ00001452371'
      end
    end
  end
end
