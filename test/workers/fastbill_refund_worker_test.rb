#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class FastbillRefundWorkerTest < ActiveSupport::TestCase
  it 'should refund normal customers' do
    fba = mock()
    FastbillAPI.stubs(:new).returns(fba)
    fba.expects(:fastbill_refund_fee)
    fba.expects(:fastbill_refund_fair)

    bt = create(:business_transaction_from_legal_entity)
    FastbillRefundWorker.new.perform(bt.id)
  end

  it 'should not refund customers that are not billed' do
    fba = mock()
    FastbillAPI.stubs(:new).returns(fba)
    fba.expects(:fastbill_refund_fee).never
    fba.expects(:fastbill_refund_fair).never

    bt = create(:business_transaction_from_marketplace_owner_account)
    FastbillRefundWorker.new.perform(bt.id)
  end
end
