class Payment < ActiveRecord::Base
  include Rails.application.routes.url_helpers # for *_url to work

  # def self.payment_attrs
  #   [:business_transactions_id]
  # end

  has_many :business_transactions, inverse_of: :payment #multiple bt can have one payment, if unified
  has_many :line_item_groups, through: :business_transactions # all bts will have the same line_item_group, so it's actually has_one, but rails doesn't understand that
  def line_item_group; line_item_groups.first; end # simulate the has_one

  delegate :article_seller, :article_seller_email, :total_price, :sold?,
           to: :business_transactions, prefix: true
  delegate :buyer, :buyer_id,
           to: :line_item_group, prefix: true

  before_validation :paypal_request #on: :create if we ever have an update

  validates :pay_key, uniqueness: true

  state_machine initial: :started do
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
            "returnUrl" => line_item_group_url(line_item_group, paid: true),
            "requestEnvelope" => {"errorLanguage" => "de_DE"},
            "currencyCode" => "EUR",
            "receiverList" => {
              "receiver" => [{"email" => business_transactions_article_seller_email, "amount" => business_transactions_total_price.to_f.to_s}]},
            "cancelUrl" => line_item_group_url(line_item_group, paid: false),
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
