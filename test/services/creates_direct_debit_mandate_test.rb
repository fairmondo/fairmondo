#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class CreatesDirectDebitMandateTest < ActiveSupport::TestCase
  describe '#create' do
    it 'creates an active direct debit mandate' do
      alice = create :user_alice
      creator = CreatesDirectDebitMandate.new alice
      mandate = creator.create

      assert_equal mandate, alice.active_direct_debit_mandate
      assert mandate.reference.present?
    end

    it 'does not create a mandate if an active one is present' do
      alice = build_stubbed :user_alice
      alice.stubs(:has_active_direct_debit_mandate?).returns(true)

      creator = CreatesDirectDebitMandate.new(alice)
      creator.create

      assert alice.direct_debit_mandates.blank?
    end

    it 'creates consecutive reference numbers consisting of user id and three digits' do
      alice = create :user_alice
      alice.stubs(:has_active_direct_debit_mandate?).returns(false)
      refs = []

      creator1 = CreatesDirectDebitMandate.new(alice)
      refs << creator1.create.reference
      creator2 = CreatesDirectDebitMandate.new(alice)
      refs << creator2.create.reference

      assert_equal([
        "#{alice.id}-001",
        "#{alice.id}-002"
      ], refs)
    end

    it 'saves the user instance after creating a mandate' do
      alice = create :user_alice, next_direct_debit_mandate_number: 1

      creator = CreatesDirectDebitMandate.new(alice)
      creator.create
      alice.reload

      assert_equal(2, alice.next_direct_debit_mandate_number)
    end
  end
end
