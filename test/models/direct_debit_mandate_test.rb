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

  describe 'methods' do
    describe '#calculate_reference' do
      it 'should return an md5 digest based on current time and user_id' do
        Time.use_zone('CET') do
          Time.stubs(:now).returns(Time.new(2016, 1, 1))
          direct_debit_mandate.user_id = 1001
          direct_debit_mandate.calculate_reference.must_equal 'EFUUXKUPS45ELY81TBVMQV8TT'
        end
      end
    end
  end

  describe 'class methods' do
    describe '#build' do
      it 'should return a valid instance when provided with user' do
        instance = DirectDebitMandate.build(user)
        assert instance.valid?
      end
    end

    describe '#creditor_identifier' do
      it 'should return Fairmondo SEPA Creditor Identifier' do
        DirectDebitMandate.creditor_identifier.must_equal 'DE15ZZZ00001452371'
      end
    end
  end
end
