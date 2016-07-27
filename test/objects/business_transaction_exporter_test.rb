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

  describe 'date' do
    it 'should only return transaction within the given time range' do
      travel_to Time.new(2016, 01, 01) do
        bt1 = create :business_transaction_from_legal_entity

        user = bt1.seller

        travel_to Time.new(2016, 04, 01) do
          bt2 = create :business_transaction_from_legal_entity, seller: user

          time_range = Time.new(2016, 03, 01)..Time.new(2016, 05, 01)
          exporter = BusinessTransactionExporter.new(user, time_range)
          assert_equal(1, exporter.query.count)

          time_range = Time.new(2015, 12, 01)..Time.new(2016, 05, 01)
          exporter = BusinessTransactionExporter.new(user, time_range)
          assert_equal(2, exporter.query.count)

          time_range = Time.new(2015, 01, 01)..Time.new(2015, 12, 01)
          exporter = BusinessTransactionExporter.new(user, time_range)
          assert_equal(0, exporter.query.count)
        end
      end
    end
  end
end
