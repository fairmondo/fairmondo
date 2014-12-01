class PaymentRefinery < ApplicationRefinery

  def default
    [:type, :pay_key]
  end
end
