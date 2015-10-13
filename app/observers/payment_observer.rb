#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PaymentObserver < ActiveRecord::Observer
  def after_create(payment)
    if payment.type == 'VoucherPayment'
      CartMailer.delay.voucher_paid_email(payment.id)
    end
  end
end
