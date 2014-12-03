class PaymentObserver < ActiveRecord::Observer

  # sends email to courier service when line_item_group is payed and ready for transport
  def after_confirm(payment)
    CartMailer.delay.courier_notification(line_item_group)
  end

end
