class Payment < ActiveRecord::Base
  include Rails.application.routes.url_helpers # for *_url to work

  # def self.payment_attrs
  #   [:transaction_id]
  # end

  belongs_to :transaction#, inverse_of: :payment
  delegate :article_seller_email, :total_price, :buyer_id, :sold?,
           to: :transaction, prefix: true

  before_validation :paypal_request #on: :create if we ever have an update

  validates :transaction_id, numericality: true, uniqueness: true
  validates :pay_key, uniqueness: true

  state_machine :initial => :started do
    state :initialized do end
    state :errored do end
    state :succeeded do end

    # event :initialize do
    #   transition :started => :initialized
    # end

    # event :error do
    #   transition [:started, :initialized] => :errored
    # end

    # event :success do
    #   transition :initialized => :succeeded
    # end
  end


  def paypal_checkout_url
    PaypalAdaptive::Response.new('payKey' => pay_key).approve_paypal_payment_url country: :de
  end

  private

    def paypal_request
      begin
        Timeout::timeout(15) do #15 second timeout
          response = paypal_client.pay(
            "returnUrl" => transaction_url(transaction, paid: true),
            "requestEnvelope" => {"errorLanguage" => "de_DE"},
            "currencyCode" => "EUR",
            "receiverList" => {
              "receiver" => [{"email" => transaction_article_seller_email, "amount" => transaction_total_price.to_f.to_s}]},
            "cancelUrl" => transaction_url(transaction, paid: false),
            "actionType" => "PAY",
            "ipnNotificationUrl" => ipn_notification_url
          )

          if response.success?
            self.pay_key = response['payKey']
            self.state = :initialized
          else
            self.error = response.errors.to_json
            self.state = :errored
          end
          true
        end
      rescue Timeout::Error
        false
      end
    end

    def paypal_client
      PaypalAdaptive::Request.new
    end
end
