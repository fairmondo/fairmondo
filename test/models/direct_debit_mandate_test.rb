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
    it { subject.must_respond_to :state }
    it { subject.must_respond_to :activated_at }
    it { subject.must_respond_to :last_used_at }
    it { subject.must_respond_to :revoked_at }
  end

  describe 'associations' do
    it { subject.must belong_to(:user) }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :user_id }
    it { subject.must validate_presence_of :reference }
    it { subject.must validate_uniqueness_of :reference }
  end

  describe 'initialization' do
    it 'should initialize a valid object' do
      assert direct_debit_mandate.valid?
    end

    it 'should not generate a new reference if one is already present' do
      direct_debit_mandate.save
      DirectDebitMandate.any_instance.stubs(:calculate_reference).returns('new_ref')
      mandate_new = DirectDebitMandate.find(direct_debit_mandate.id)
      mandate_new.reference.wont_equal 'new_ref'
    end
  end

  describe 'reference calculation' do
    it 'should create a hash reference based on user_id and current time' do
      Time.stubs(:now).returns(Time.utc(2016, 1, 1))
      user = FactoryGirl.build_stubbed(:user, id: 1001)
      mandate = DirectDebitMandate.new(user: user)
      mandate.reference.must_equal '7WDGNBWREJM7E9XIAN5YJ483W'
    end
  end

  describe 'class methods' do
    describe '#creditor_identifier' do
      it 'should return Fairmondo SEPA Creditor Identifier' do
        DirectDebitMandate.creditor_identifier.must_equal 'DE15ZZZ00001452371'
      end
    end
  end

  describe 'methods' do
    describe '#reference_date' do
      it 'should return the date of created_at' do
        travel_to Time.new(2016, 4, 1, 12)
        mandate = FactoryGirl.create(:direct_debit_mandate)
        travel_back
        mandate.reference_date.to_s.must_equal '2016-04-01'
      end

      it 'should return the date of today if not saved to the database' do
        direct_debit_mandate.reference_date.must_equal Date.current
      end
    end
  end

  describe 'state' do
    it 'should be new for a new instance' do
      direct_debit_mandate.state.must_equal 'new'

      direct_debit_mandate.activated_at.must_be_nil
      direct_debit_mandate.revoked_at.must_be_nil
    end

    it 'should be able to get activated' do
      direct_debit_mandate.activate!

      direct_debit_mandate.state.must_equal 'active'
      direct_debit_mandate.activated_at.wont_be_nil
    end

    it 'should be able to get inactive if active' do
      direct_debit_mandate.activate!
      direct_debit_mandate.deactivate!

      direct_debit_mandate.state.must_equal 'inactive'
    end

    it 'should be able to get revoked if active' do
      direct_debit_mandate.activate!
      direct_debit_mandate.revoke!

      direct_debit_mandate.state.must_equal 'revoked'
      direct_debit_mandate.revoked_at.wont_be_nil
    end
  end
end
