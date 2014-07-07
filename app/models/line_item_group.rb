class LineItemGroup < ActiveRecord::Base
  extend Sanitization

  belongs_to :seller, class_name: 'User', foreign_key: 'user_id', inverse_of: :line_item_groups
  belongs_to :cart, inverse_of: :line_item_groups
  has_many :line_items, dependent: :destroy, inverse_of: :line_item_group
  has_many :articles, through: :line_items
  has_many :business_transactions, inverse_of: :line_item_group

  auto_sanitize :message

  with_options if: :has_business_transactions? do |bt|
    bt.validates :unified_payment_method, inclusion: { in: proc { |record| record.unified_payments_selectable } }, common_sense: true, presence: true, if: :payment_can_be_unified?

    bt.validates :tos_accepted , acceptance: true

    bt.validates_each :unified_transport, :unified_payment do |record, attr, value|
      record.errors.add(attr, 'not allowed') if value && !can_be_unified_for?(record,attr)
    end
  end

  def transport_can_be_unified?
    articles_with_unified_transport_count = self.line_items.joins(:article).where("articles.unified_transport = ?", true ).count
    @transport_can_be_unified ||= (articles_with_unified_transport_count >= 2)
  end

  def payment_can_be_unified?
     self.articles.count > 1 && unified_payments_selectable.any?
  end

  def unified_payments_selectable
    @unified_payments_selectable ||= ( self.line_items.map{|l| l.article.selectable_payments}.inject(:&) || [] ) #intersection of selectable_payments
  end

  private
    def self.can_be_unified_for? record, type
      record.transport_can_be_unified? if type == :unified_transport
      record.payment_can_be_unified? if type == :unified_payment
    end

    def has_business_transactions?
      self.business_transactions.any?
    end

end
