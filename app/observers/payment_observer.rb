class PaymentObserver < ActiveRecord::Observer

  def after_create(payment)
    if payment.type == 'VoucherPayment'
      CartMailer.delay.voucher_paid_email(payment.id)
    end
  end
end
