class Payment < ActiveRecord::Base
  include Rails.application.routes.url_helpers # for *_url to work

  def self.payment_attrs
    []
  end

  belongs_to :transaction#, inverse_of: :payment
  delegate :article_seller_email, :total_price, to: :transaction, prefix: true

  def paypal_request
    paypal_client.pay(
      "returnUrl" => transaction_url(transaction),
      "requestEnvelope" => {"errorLanguage" => "de"},
      "currencyCode" => "EUR",
      "receiverList" => {
        "receiver" => [{"email" => transaction_article_seller_email, "amount" => transaction_total_price}]},
      "cancelUrl" => root_url,
      "actionType" => "PAY",
      "ipnNotificationUrl" => root_url
    )
  end

  private

    def paypal_client
      PaypalAdaptive::Request.new
    end
end
