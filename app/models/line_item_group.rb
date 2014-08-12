class LineItemGroup < ActiveRecord::Base
  extend Sanitization

  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id', inverse_of: :seller_line_item_groups
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id', inverse_of: :buyer_line_item_groups
  belongs_to :cart, inverse_of: :line_item_groups, counter_cache: :line_item_count
  has_many :line_items, dependent: :destroy, inverse_of: :line_item_group
  #has_many :articles through either :line_items or :business_transactions
  def articles
    (business_transactions.any? ? business_transactions : line_items).map(&:article)
  end
  has_many :business_transactions, inverse_of: :line_item_group
  has_many :payments, through: :business_transactions, inverse_of: :line_item_groups
  belongs_to :transport_address, class_name: 'Address', foreign_key: 'transport_address_id'
  belongs_to :payment_address, class_name: 'Address', foreign_key: 'payment_address_id'
  has_one :rating

  delegate :email, :bank_account_owner, :iban, :bic, :bank_name, :nickname,
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
    bt.validates :transport_address, :payment_address, :buyer, :seller, presence: true
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
    super value
    self.business_transactions.each do |bt|
      bt.selected_payment = value
    end
  end

  def unified_transport= value
    super
    self.business_transactions.each{ |bt| bt.selected_transport = nil } if value
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
