class PaymentRefinery < ApplicationRefinery

  def default
    [:type, :pay_key, :line_item_group_id]
  end

  def ipn_notification
    [:txn_id, :payment_status, :receiver_email]
  end
end
