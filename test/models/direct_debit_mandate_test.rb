#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe DirectDebitMandate do
  subject { DirectDebitMandate.new }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :reference }
  end

  describe 'associations' do
    it { subject.must belong_to(:user) }
  end

  describe 'class methods' do
    describe 'creditor_identifier' do
      it 'should return Fairmondo SEPA Creditor Identifier' do
        DirectDebitMandate.creditor_identifier.must_equal 'DE15ZZZ00001452371'
      end
    end
  end
end
