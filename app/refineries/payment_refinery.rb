class PaymentRefinery < ApplicationRefinery

  def default
    [:type, :pay_key, :line_item_group_id]
  end

end
