#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class DirectDebitMandateTest < ActiveSupport::TestCase
  subject { DirectDebitMandate.new }
  let(:user) { build_stubbed :user }
  let(:mandate) { DirectDebitMandate.new(user: user) }

  describe 'attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :user_id }
    it { _(subject).must_respond_to :reference }
    it { _(subject).must_respond_to :state }
    it { _(subject).must_respond_to :activated_at }
    it { _(subject).must_respond_to :last_used_at }
    it { _(subject).must_respond_to :revoked_at }
  end

  describe 'associations' do
    should belong_to(:user)
  end

  describe 'validations' do
    should validate_presence_of :user_id
    should validate_presence_of :reference
    should validate_uniqueness_of :reference
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
        mandate = DirectDebitMandate.create(user: user, reference: '001')
        travel_back

        mandate.reference_date.to_s.must_equal '2016-04-01'
      end
    end

    describe '#to_s' do
      it 'should return reference and reference date' do
        mandate = DirectDebitMandate.new
        mandate.stubs(:reference).returns('REFERENCE')
        date = Date.new(2016, 4, 1)
        mandate.stubs(:reference_date).returns(date)

        mandate.to_s.must_equal "REFERENCE (#{I18n.l(date)})"
      end
    end
  end

  describe 'state' do
    before do
      mandate.reference = '001'
    end

    it 'should be new for a new instance' do
      mandate.state.must_equal 'new'
      mandate.activated_at.must_be_nil
      mandate.revoked_at.must_be_nil
    end

    it 'should be able to get activated' do
      mandate.activate!

      mandate.state.must_equal 'active'
      mandate.activated_at.wont_be_nil
    end

    it 'should be able to get inactive if active' do
      mandate.activate!
      mandate.deactivate!

      mandate.state.must_equal 'inactive'
    end

    it 'should be able to get revoked if active' do
      mandate.activate!
      mandate.revoke!

      mandate.state.must_equal 'revoked'
      mandate.revoked_at.wont_be_nil
    end
  end
end
