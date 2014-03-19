Class RefundObserver < ActiveRecord::Observer
  def after_create refund
    RefundMailer.refund_notification( refund ).deliver
  end
end
