class PaymentRefinery < ApplicationRefinery

  def default
    [:type, :pay_key, :line_item_group_id]
  end

  def ipn_notification
    [:pay_key, :status, :sender_email]
  end
end
