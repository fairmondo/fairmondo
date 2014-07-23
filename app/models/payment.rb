class Payment < ActiveRecord::Base

  has_many :business_transactions, inverse_of: :payment #multiple bt can have one payment, if unified
  has_many :line_item_groups, through: :business_transactions, inverse_of: :payments
  # all bts will have the same line_item_group, so it's actually has_one, but rails doesn't understand that
  def line_item_group; line_item_groups.first; end # simulate the has_one

  delegate :total_price,
           to: :business_transactions, prefix: true
  delegate :buyer, :buyer_id, :seller, :seller_email,
           to: :line_item_group, prefix: true

  validates :pay_key, uniqueness: true, on: :update

  state_machine initial: :pending do

    state :pending, :requesting, :initialized, :errored, :succeeded

    event :init do
      transition :pending => :initialized, if: :paypal_request
      transition :pending => :errored
    end

    # event :success do
    #   transition :initialized => :succeeded
    # end
  end


  def paypal_checkout_url
    PaypalAPI.checkout_url pay_key
  end

  def total_price
    business_transactions.map(&:total_price).sum
  end

  private

    # called within init
    def paypal_request
      response = PaypalAPI.new.request_for(self)
      if response.success?
        self.pay_key = response['payKey']
        true # continue
      else
        self.error = response.errors.to_json
        false # errored instead of initialized
      end
    end

end
