#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe CreatesDirectDebitMandate do
  let(:alice) { build_stubbed :user_alice_with_bank_details }

  describe 'initialisation' do
    it 'succeeds with a user object' do
      creator = CreatesDirectDebitMandate.new alice
      creator.wont_be_nil
    end
  end

  describe '#create' do
    it 'creates an active direct debit mandate' do
      creator = CreatesDirectDebitMandate.new alice
      creator.create

      assert alice.has_active_direct_debit_mandate?
    end

    it 'does not create a mandate if an active one is present' do
      alice.stubs(:has_active_direct_debit_mandate?).returns(true)

      creator = CreatesDirectDebitMandate.new(alice)
      creator.create

      assert alice.direct_debit_mandates.blank?
    end
  end
end
