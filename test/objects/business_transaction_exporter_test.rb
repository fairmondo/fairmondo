#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe BusinessTransactionExporter do
  let(:bt_from_legal_entity) { create :business_transaction_from_legal_entity }

  describe 'basic tests' do
    it 'should return the count' do
      bt_from_legal_entity
      BusinessTransaction.count.must_equal 1
    end
  end

  describe 'integration tests' do
    it 'should export articles' do
      exporter = BusinessTransactionExporter.new

      exporter.export.must_equal([])
    end
  end
end
