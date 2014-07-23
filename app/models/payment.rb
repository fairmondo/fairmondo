class Payment < ActiveRecord::Base

  has_many :business_transactions, inverse_of: :payment #multiple bt can have one payment, if unified
  has_many :line_item_groups, through: :business_transactions # all bts will have the same line_item_group, so it's actually has_one, but rails doesn't understand that
  def line_item_group; line_item_groups.first; end # simulate the has_one

  delegate :total_price,
           to: :business_transactions, prefix: true
  delegate :buyer, :buyer_id, :seller, :seller_email,
           to: :line_item_group, prefix: true

  validates :pay_key, uniqueness: true, presence:true, on: :update

  state_machine initial: :pending do

    state :initialized do end
    state :errored do end
    state :succeeded do end

    event :init do
      transition :pending => :initialized
    end
    before_transition on: :init, do: :paypal_request

    event :erroring do
      transition [:pending, :initialized] => :errored
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

    def paypal_request
      PaypalAPI.new.request_for self
    end

end
