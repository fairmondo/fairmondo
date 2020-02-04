#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RefundObserver < ActiveRecord::Observer
  def after_create refund
    bt = refund.business_transaction
    FastbillRefundWorker.perform_async bt.id
    RefundMailer.refund_notification(refund).deliver_later
  end
end
