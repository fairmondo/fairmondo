#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe BusinessTransactionExporter do
  let(:bt) { create :business_transaction_from_legal_entity }

  describe 'integration tests' do
    it 'should return a csv string with the business transactions' do
      FactoryGirl.reload

      travel_to Time.new(2016, 04, 01, 12) do
        user = bt.seller

        exporter = BusinessTransactionExporter.new(user)

        expected_csv = File.read('test/fixtures/business_transaction_export1.csv')

        assert_equal(expected_csv, exporter.csv_string)
      end
    end
  end
end
