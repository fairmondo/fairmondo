class LineItemGroup < ActiveRecord::Base
  extend Sanitization

  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id', inverse_of: :seller_line_item_groups
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id', inverse_of: :buyer_line_item_groups
  belongs_to :cart, inverse_of: :line_item_groups
  has_many :line_items, dependent: :destroy, inverse_of: :line_item_group
  has_many :articles, through: :line_items
  has_many :business_transactions, inverse_of: :line_item_group
  has_many :payments, inverse_of: :line_item_group
  has_one :paypal_payment, -> { where type: 'PaypalPayment' }, class_name: 'Payment'
  belongs_to :transport_address, class_name: 'Address', foreign_key: 'transport_address_id'
  belongs_to :payment_address, class_name: 'Address', foreign_key: 'payment_address_id'
  has_one :rating

  delegate :email, :bank_account_owner, :iban, :bic, :bank_name, :nickname,
           :paypal_account, :free_transport_at_price, :free_transport_available,
           to: :seller, prefix: true

  delegate :email, :nickname,
           to: :buyer, prefix: true
  delegate :value, to: :rating, prefix: true

  monetize :unified_transport_price_cents, :allow_nil => true
  monetize :free_transport_at_price_cents, :allow_nil => true

  auto_sanitize :message

  scope :sold , -> { where(tos_accepted: true) }

  with_options if: :has_business_transactions? do |bt|
    bt.validates :unified_payment_method, inclusion: { in: proc { |record| record.unified_payments_selectable } }, common_sense: true, presence: true, if: :payment_can_be_unified?

    bt.validates :tos_accepted, acceptance: { allow_nil: false, accept: true }

    bt.validates_each :unified_transport, :unified_payment do |record, attr, value|
      record.errors.add(attr, 'not allowed') if value && !can_be_unified_for?(record,attr)
    end
    bt.validates :transport_address, :payment_address, :buyer_id, :seller_id, presence: true
    bt.validate :no_unified_transports_with_cash_on_delivery
  end

  def transport_can_be_unified?
    return false unless self.seller.unified_transport_available?
    articles_with_unified_transport_count = self.line_items.joins(:article).where("articles.unified_transport = ?", true ).count
    @transport_can_be_unified ||= (articles_with_unified_transport_count >= 2)
  end

  def payment_can_be_unified?
    self.articles.count > 1 && unified_payments_selectable.any?
  end

  def unified_payments_selectable
    @unified_payments_selectable ||= ( self.line_items.map{|l| l.article.selectable_payments}.inject(:&) || [] ) #intersection of selectable_payments
  end

  def unified_payment_method= value
    super
    self.business_transactions.each do |bt|
      bt.selected_payment = value if self.unified_payment?
    end
  end

  def unified_transport= value
    super
    self.business_transactions.each{ |bt| bt.selected_transport = nil if bt.is_in_unified_transport? }
  end

  def generate_purchase_id
    self.update_column(:purchase_id, self.id.to_s.rjust(8, '0').prepend('F'))
  end

  def seller_has_other_articles?
    ids = line_items.map(&:article_id)
    return true if seller.articles.active.where('id NOT IN (?)', ids).first
    false
  end

  ##################
  #                #
  # State machines #
  #                #
  ##################

  # State machine for payment state
  #
  state_machine :payment_state, initial: :pending do
    state :payment_pending do
      # waiting for payment
    end

    state :payment_sent do
      # payment was initialized, waiting for confirmation
    end

    state :payment_completed do
      # payment has been received and confirmed
    end

    state :payment_refund_sent do
      # payment has been refunded
    end

    state :payment_refund_received do
      # refunded monex has been received
    end

    state :payment_error do
      # payment did not succeed
    end

    event :send_payment do
      transition :payment_pending => :payment_sent
    end

    event :confirm_payment do
      transition :payment_sent => :payment_completed
    end

    event :refund_money do
      transition :payment_completed => :payment_refund_sent
    end

    event :confirm_refund do
      transition :payment_refund_sent => :payment_refund_received
    end

    event :set_payment_error do
      transition [:pending, :payment_sent] => :payment_error
    end
  end

  # State machine for transport state
  #
  state_machine :transport_state, initial: :pending do
    state :transport_pending do
      # waiting for transport confirmation
    end

    state :transport_ready do
      # package is ready for shipment but not yet shipped
    end

    state :transport_shipped do
      # package has been shipped
    end

    state :transport_received do
      # package has been received
    end

    state :transport_returned do
      # package has been sent back
    end

    state :transport_returned_received do
      # sent back package has been received
    end

    event :transport_confirm_ready do
      transition :transport_pending => :transport_ready
    end

    event :transport_confirm_shipped do
      transition :transport_ready => :transport_shipped
    end

    event :transport_confirm_received do
      transition :transport_shipped => :transport_received
    end

    event :transport_send_back do
      transition :transport_received => :transport_returned
    end
  end

  private
    def self.can_be_unified_for? record, type
      if type == :unified_transport
        record.transport_can_be_unified?
      elsif type == :unified_payment
        record.payment_can_be_unified?
      end
    end

    def has_business_transactions?
      self.business_transactions.any?
    end

    def cash_on_delivery_with_unified_transport?
      self.business_transactions.to_a.select{ |bt| bt.article.unified_transport? && bt.selected_payment.cash_on_delivery? }.any?
    end

    def no_unified_transports_with_cash_on_delivery
      if self.unified_transport? && cash_on_delivery_with_unified_transport?
        errors.add(:unified_transport, I18n.t('transaction.errors.cash_on_delivery_with_unified_transport'))
      end
    end

end
