#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PaymentObserver < ActiveRecord::Observer
  def after_create(payment)
    if payment.type == 'VoucherPayment'
      CartMailer.voucher_paid_email(payment.id).deliver_later
    end
  end
end
