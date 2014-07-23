class PaypalAPI
  include Rails.application.routes.url_helpers # for *_url to work

  def self.checkout_url pay_key
    PaypalAdaptive::Response.new('payKey' => pay_key).approve_paypal_payment_url country: :de
  end

  def request_for payment
    begin
      Timeout::timeout(15) do #15 second timeout
        paypal_client.pay(
          "returnUrl" => line_item_group_url(payment.line_item_group, paid: true),
          "requestEnvelope" => {"errorLanguage" => "de_DE"},
          "currencyCode" => "EUR",
          "receiverList" => {
            "receiver" => [{"email" => payment.line_item_group_seller_email, "amount" => payment.total_price.to_f.to_s}]},
          "cancelUrl" => line_item_group_url(payment.line_item_group, paid: false),
          "actionType" => "PAY",
          "ipnNotificationUrl" => ipn_notification_url
        )
      end
    rescue Timeout::Error
      Struct.new(:success?, :errors).new(false, 'Timeout') # Mock response object
    end
  end

  private
    def paypal_client
      PaypalAdaptive::Request.new
    end
end